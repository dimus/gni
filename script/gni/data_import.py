#!/usr/bin/env python
import os
import sys
from urllib import urlopen
import libxml2
import MySQLdb
import yaml
import marshal
import sha
import time
from optparse import OptionParser

import cProfile
    
import pprint
pp = pprint.PrettyPrinter(indent=2)



class DbImporter: #{{{1

  def escape_data(self,data): #{{{2
    for key in data.keys():
      if data[key]:
        if type(data[key]) == type(''):
          data[key] = "'" + MySQLdb.escape_string(str(data[key])) + "'"
      else:
        data[key] = 'null'
      for key in ('url','local_id','global_id'):
        if not data.has_key(key):
          data[key] = 'null'
    return data

  def __init__(self, environment): #{{{2
    self.environment = environment
    self.conn = self._connect()
    self.cursor = self.conn.cursor() 

  def _connect(self):
    db_data = os.popen('erb ' + sys.path[0] + '/../../config/database.yml').read()
    db_conf =  yaml.load(db_data)[self.environment]
    if not db_conf.has_key('socket'):
        db_conf['socket'] = "/tmp/mysql.sock"

    conn = MySQLdb.connect (
        host = db_conf['host'],
        user = db_conf['username'],
        passwd = db_conf['password'],
        unix_socket = db_conf['socket'],
        db = db_conf['database'])
    return conn


class Importer: #{{{1

  def __init__(self, source, data_source_id, environment): #{{{2
    self.db = DbImporter(environment)
    self.duplicated = []
    self.deleted = []
    self.inserted = []
    self.changed = []
    self.imported_data = {}
    self.counter = 0
    self.time = time.time()

    self.reader = libxml2.newTextReaderFilename(source)
    self.data_source_id = data_source_id

    self._current_tag = None
    self._record = self._reset_record()

  def parse(self): #{{{2
    ret = self.reader.Read()
    while ret == 1:
      self._process_node()
      ret = self.reader.Read()
    if ret != 0:
        raise RuntimeError("%s : failed to parse" % (filename))

    c = self.db.cursor
    c.execute("select name_string_id from name_indices where data_source_id = %s" % self.data_source_id)
    self._old_ids = set(map(lambda x: x[0], c.fetchall()))
    self._new_ids = set(self.imported_data.keys())

  def get_deleted(self): #{{{2
    try: 
      self.deleted = self._old_ids.difference(self._new_ids)
    except:
      print "run parse command first"
  
  def get_inserted(self): #{{{2
    try:
      self.inserted = self._new_ids.difference(self._old_ids)
    except:
      print "run parse command first"
  
  def get_changed(self): #{{{2
    c = self.db.cursor
    #prepare data for checking updates
    to_check = self._old_ids.intersection(self._new_ids)
    to_check = list(to_check)
    to_check.sort()
    

    slice_size = min_slice = 128
    max_slice = len(to_check)/20
    while len(to_check):
        slice = to_check[0:slice_size]
        print slice_size
        lookup_ids = []
        new_data = []
        for i in slice:
            d = self.imported_data[i]
            local_id = global_id = url = None
            if d.has_key('url'): url = d['url']
            if d.has_key('local_id'): local_id = d['local_id']
            if d.has_key('global_id'): global_id = d['global_id']  
            new_data.append((url, local_id, global_id))
            lookup_ids.append(i)
        c.execute("select url, local_id, global_id from name_indices where data_source_id = %s and name_string_id in (%s) order by name_string_id" % (self.data_source_id,  ",".join(map(lambda x: str(x),lookup_ids))))
        #print sha.new(marshal.dumps(tuple(new_data))).digest()
        #print sha.new(marshal.dumps(c.fetchall())).digest()
        if sha.new(marshal.dumps(c.fetchall())).digest() == sha.new(marshal.dumps(tuple(new_data))).digest():
            to_check = to_check[slice_size:]
            if slice_size * 2 < max_slice:
                slice_size *= 2
        elif slice_size > min_slice:
            slice_size /= 2
        else:
            for i in slice:
                new_data = self.imported_data[i]
                c.execute("select url, local_id, global_id from name_indices where data_source_id = %s and name_string_id = %s", (self.data_source_id, i))
                res = c.fetchone()
                for key in ('url', 'local_id', 'global_id'):
                  if not new_data.has_key(key): new_data[key] = None
                if tuple([new_data['url'], new_data['local_id'], new_data['global_id']]) != res:
                    #pp.pprint(tuple([new_data['url'], new_data['local_id'], new_data['global_id']]))
                    #pp.pprint(res)
                    self.changed.append(i)
            to_check = to_check[slice_size:]

  def db_delete(self): #{{{2
    if self.deleted:
      delete_ids = ",".join(map(lambda x: str(x), self.deleted))
      self.db.cursor.execute("delete from name_indices where data_source_id = %s and name_string_id in (%s)" % (self.data_source_id, delete_ids))

  def db_insert(self): #{{{2
    if self.inserted:
      inserts = []
      for i in self.inserted:
        data = self.db.escape_data(self.imported_data[i])
        data['name_string_id'] = i
        data['data_source_id'] = self.data_source_id
        inserts.append("(%(data_source_id)s , %(name_string_id)s, %(url)s, %(local_id)s, %(global_id)s, now(), now())" % data)
      self.db.cursor.execute("insert into name_indices (data_source_id, name_string_id, url, local_id, global_id, created_at, updated_at) values %s" % ",".join(inserts))
 
  def db_update(self): #{{{2
      c = self.db.cursor
      for i in self.changed:
          new_data = self.imported_data[i]
          data = self.db.escape_data(new_data)
          data['data_source_id'] = self.data_source_id
          data['name_string_id'] = i
          c.execute("update name_indices set url = %(url)s, global_id = %(global_id)s, local_id = %(local_id)s where data_source_id = %(data_source_id)s and name_string_id = %(name_string_id)s" % data)

  def db_store_statistics(self): #{{{2
    #c.execute("delete from import_details where created_at 
    self._import_stats(self.deleted, 'delete')
    self._import_stats(self.inserted, 'insert')
    self._import_stats(self.changed, 'update')
    self._import_stats(self.duplicated, 'dedupe')
    return "Deleted: %s, Inserted: %s, Changed: %s, Duplicated: %s" % (len(self.deleted), len(self.inserted), len(self.changed), len(self.duplicated))
  
  def db_commit(self): #{{{2
    self.db.conn.commit()

  #private functions #{{{2
  def _import_stats(self, data, name): #{{{2
      c = self.db.cursor
      if len(data):
          c.execute("insert into data_source_imports (data_source_id, action, created_at, updated_at) values (%s, %s, now(), now())", (self.data_source_id, name))
          c.execute("select last_insert_id()")
          imports_id = c.fetchone()[0]
          inserts = []
          for i in data:
              inserts.append("(%s, %s, now(), now())" % (imports_id, i))
          c.execute("insert into data_source_import_details (data_source_import_id, name_string_id, created_at, updated_at) values %s" % ",".join(inserts))

  def _process_node(self): #{{{2
    if self.reader.NodeType() == 1: #start of a tag
        if self.reader.Name() == "dwc:ScientificName":
            self._current_tag = "raw_name"    
        elif self.reader.Name() == "dc:source":
            self._current_tag = "url"
        elif self.reader.Name() == "dc:identifier":
            self._current_tag = "local_id"
        elif self.reader.Name() == "dwc:GlobalUniqueIdentifier":
            self._current_tag = "global_id"
        else:
            self._current_tag = None
    elif self.reader.NodeType() == 15: #end of a tag
        if self.reader.Name() == "record":
            self.counter += 1
            if self.counter % 10000 == 0:
              new_time = time.time()
              print self.counter, "%2dsec" % (new_time - self.time)
              self.time = new_time
            name_string_id = self._prepare_record()
            self._append_imported_data(name_string_id)
            self._record = self._reset_record()
    elif self.reader.NodeType() == 3 and self._current_tag: #text node
        self._record[self._current_tag] = self.reader.Value().strip()
        self._current_tag = None

  def _prepare_record(self): #{{{2
      self.db.cursor.execute("select id from name_strings where name = %s", self._record['raw_name'])
      name_string_id = self.db.cursor.fetchone()
      if not name_string_id:
          self.db.cursor.execute("insert into name_strings (name, created_at, updated_at) values (%s, now(), now())", self._record['raw_name'])
          self.db.cursor.execute("select last_insert_id()")
          name_string_id = self.db.cursor.fetchone()
      return (name_string_id[0])    
    
  def _append_imported_data(self, name_string_id): #{{{2
    if not self._is_duplicate(name_string_id):
        self.imported_data[name_string_id] = self._record.copy()

  def _is_duplicate(self, name_string_id): #{{{2
      duplicate = False
      if self.imported_data.has_key(name_string_id):
          for s in ('local_id', 'url', 'global_id'):
              if self._record.has_key(s):
                  pp.pprint(self._record)
                  pp.pprint(self.imported_data[name_string_id])
                  if self.imported_data[name_string_id].has_key(s) and self._record[s] == self.imported_data[name_string_id][s]: 
                      duplicate = True
                      break
      return duplicate

  def _reset_record(self): #{{{2
    return {'data_source_id': self.data_source_id}


if __name__ == '__main__': #script part {{{1
    opts = OptionParser()
    opts.add_option("-e", "--environment", dest="environment", default="development",
                      help="Specifies the environment of the system (development|test|producton).")

    opts.add_option("-s", "--source", dest="source",
                      help="Specifies url/filename which contains data for harvesting.")

    opts.add_option("-i", "--source-id", dest="source_id",
                      help="Identifier of the data_source in GNA database.")

    (options, args) = opts.parse_args()

    if not (options.source and options.source_id and type(int(options.source_id)) == type(1)):
        raise Exception("source file/url and source id are required")

    i = Importer(options.source, options.source_id, options.environment)
#cProfile.run('i.parse()')
    i.parse()
    print "parsing is done"
    i.get_deleted()
    i.get_inserted()
    i.get_changed()
    if (i.deleted or i.inserted or i.changed):
        i.db_delete()
        i.db_insert()
        i.db_update()
        print i.db_store_statistics()
    i.db_commit()
