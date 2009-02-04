#!/usr/bin/env python
import os
import sys
from urllib import urlopen
import libxml2
import MySQLdb
import yaml
import cjson
import sha
import time
from optparse import OptionParser

import cProfile
    
import pprint
pp = pprint.PrettyPrinter(indent=2)
packet_size = 5000

class DbImporter: #{{{1

  def escape_data(zself,data): #{{{2
    for key in data.keys():
      if data[key]:
        if type(data[key]) == type(''):
          data[key] = "'" + MySQLdb.escape_string(str(data[key])) + "'"
      else:
        data[key] = 'null'
      for key in ('source','identifier','GlobalUniqueIdentifier', 'Kingdom', 'Rank'):
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
    self.deleted = []
    self.inserted = []
    self.changed = []
    self.imported_data = {}
    self.counter = 0
    self.time = time.time()
    self.kingdoms = self._prepare_kingdoms()

    self.reader = libxml2.newTextReaderFilename(source)
    self.data_source_id = data_source_id

    self._current_tag = None
    self._record = self._reset_record()

  def parse(self): #{{{2
    ret = self.reader.Read()
    while ret == 1:
      for i in self._process_node():
          yield i
      ret = self.reader.Read()
    if ret != 0:
        raise RuntimeError("%s : failed to parse" % (filename))

    self._add_hash_to_imports()
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
            h = self.imported_data[i]['hash']
            new_data.append((h,))
            lookup_ids.append(i)
        c.execute("select records_hash from name_indices where data_source_id = %s and name_string_id in (%s) order by name_string_id" % (self.data_source_id,  ",".join(map(lambda x: str(x),lookup_ids))))
        if sha.new(cjson.encode(c.fetchall())).hexdigest() == sha.new(cjson.encode(tuple(new_data))).hexdigest():
            to_check = to_check[slice_size:]
            if slice_size * 2 < max_slice:
                slice_size *= 2
        elif slice_size > min_slice:
            slice_size /= 2
        else:
            for i in slice:
                new_data = (self.imported_data[i]['hash'],)
                c.execute("select records_hash from name_indices where data_source_id = %s and name_string_id = %s", (self.data_source_id, i))
                res = c.fetchone()
                if new_data != res:
                    #pp.pprint(new_data)
                    #pp.pprint(res)
                    #pp.pprint(i)
                    self.changed.append(i)
            to_check = to_check[slice_size:]

  def find_overlaps(self):  #{{{2
      c = self.db.cursor
      c.execute("delete from data_source_overlaps where data_source_id_1 = %s or data_source_id_2 = %s", (self.data_source_id, self.data_source_id))
      c.execute("select id from data_sources where id != %s", self.data_source_id)
      data_sources = map(lambda x: x[0], c.fetchall())
      data_sources.sort
      overlap_data = []
      for i in data_sources:
          c.execute("select name_string_id from name_indices where data_source_id = %s", i)
          other_data_source_name_ids = set(map(lambda x: x[0], c.fetchall()))
          intersect_size = len(self._new_ids.intersection(other_data_source_name_ids))
          overlap_data.append("(%s, %s, %s, now(), now())" % (self.data_source_id, i, intersect_size))
      c.execute("insert into data_source_overlaps (data_source_id_1, data_source_id_2, strict_overlap, created_at, updated_at) values %s" % ",".join(overlap_data))

  def db_delete(self): #{{{2
    if self.deleted:
      delete_ids = ",".join(map(lambda x: str(x), self.deleted))
      self.db.cursor.execute("select id from name_indices where data_source_id = %s and name_string_id in (%s)" % (self.data_source_id, delete_ids))
      delete_ids = map(lambda x: x[0], self.db.cursor.fetchall())
      delete_ids = ",".join(map(lambda x: str(x), delete_ids))
      self.db.cursor.execute("delete from name_index_records where name_index_id in (%s)" % delete_ids)
      self.db.cursor.execute("delete from name_indices where id in (%s)" % delete_ids)

  def db_insert(self): #{{{2
      c = self.db.cursor
      c.execute('select max(id) from name_indices')
      res = c.fetchall()
      if res[0][0]:
          last_id = res[0][0]
      else:
          last_id = 0 
      insert_query = "insert into name_indices (data_source_id, name_string_id, records_hash, created_at, updated_at) values %s"
      if self.inserted:
          inserts = []
          count = 0
          for i in self.inserted:
              count += 1
              #data = self.db.escape_data(self.imported_data[i])
              data = {}
              data['name_string_id'] = i
              data['data_source_id'] = self.data_source_id
              data['records_hash'] = self.imported_data[i]['hash'] 
              inserts.append("(%(data_source_id)s, %(name_string_id)s, '%(records_hash)s' , now(), now())" % data)
              if len(inserts) >= packet_size:
                c.execute(insert_query % ",".join(map(lambda x: str(x),inserts)))
                #print(':mysql: inserted ' + str(count))
                inserts=[]
          if inserts:
              c.execute(insert_query % ",".join(map(lambda x: str(x),inserts)))
          
          #print("select id, name_string_id from name_indices where data_source_id = %s and id > %s" % (self.data_source_id, last_id) )
          c.execute("select id, name_string_id from name_indices where data_source_id = %s and id > %s" % (self.data_source_id, last_id) )
          #print(':mysql: name_indices inserts are done')
          res = c.fetchall()
          records = []
          count = 0
          insert_query = "insert into name_index_records (name_index_id, record_hash, url, local_id, global_id, kingdom_id, rank, created_at, updated_at) values %s"
          for i in res:
              count += 1
              name_index_id = i[0]
              name_string_id = i[1]
              for d in self.imported_data[name_string_id]['data']:
                  data = self.db.escape_data(d)
                  data['name_index_id'] = name_index_id
                  records.append("(%(name_index_id)s, %(hash)s, %(source)s, %(identifier)s, %(GlobalUniqueIdentifier)s, %(Kingdom)s, %(Rank)s, now(), now())" % data)
                  if len(records) >= packet_size:
                      c.execute(insert_query % ",".join(records)) 
                      #print(':mysql: records ' + str(count))
                      records=[]
          if records:
              c.execute(insert_query % ",".join(records)) 
          #print(':mysql: name_index_records inserts are done')
  def db_update(self): #{{{2
      c = self.db.cursor
      if self.changed:
          c.execute("select id, name_string_id from name_indices where  name_string_id in (%s)" % ",".join(map(lambda x: str(x), self.changed)))
          res = c.fetchall()
          updates = map(lambda x: str(x[0]), res)
          c.execute("delete from name_index_records where name_index_id in (%s)" % ",".join(updates))
          for i in res:
              name_string_id = i[1]
              name_index_id = i[0]
              hash = self.imported_data[name_string_id]['hash']
              c.execute("update name_indices set records_hash = %s where data_source_id = %s and name_string_id = %s", (hash, self.data_source_id, name_string_id))
              records = []
              for d in self.imported_data[i[1]]['data']:
                  data = self.db.escape_data(d)
                  data['name_index_id'] = name_index_id
                  #pp.pprint(data)
                  records.append("(%(name_index_id)s, %(hash)s, %(source)s, %(identifier)s, %(GlobalUniqueIdentifier)s, %(Kingdom)s, %(Rank)s, now(), now())" % data)
              c.execute("insert into name_index_records (name_index_id, record_hash, url, local_id, global_id, kingdom_id, rank, created_at, updated_at) values %s" % ",".join(records)) 

  def db_store_statistics(self): #{{{2
    #c.execute("delete from import_details where created_at 
    self._import_stats(self.deleted, 'delete')
    self._import_stats(self.inserted, 'insert')
    self._import_stats(self.changed, 'update')
    return "Deleted: %s, Inserted: %s, Changed: %s" % (len(self.deleted), len(self.inserted), len(self.changed))
  
  def db_commit(self): #{{{2
    self.db.conn.commit()

  #private functions #{{{2
  def _prepare_kingdoms(self):
      c = self.db.cursor
      c.execute("select n.id, n.name from kingdoms k join name_strings n on n.id = k.name_string_id")
      res = c.fetchall()
      kingdoms = {}
      for i in res:
        kingdoms[i[1].lower()] = i[0]
      return kingdoms

  def _add_hash_to_imports(self):
      imp =  self.imported_data
      for key in imp.keys():
          hashes = [] 
          for d in imp[key]['data']:
              data_keys = d.keys()
              data_keys.sort()
              data_array = map(lambda x: d[x], data_keys)
              normalized_data = cjson.encode(data_array).replace(' ','')
              #print normalized_data
              normalized_data = sha.new(normalized_data).hexdigest()
              #print normalized_data
              d['hash'] = normalized_data
              hashes.append(normalized_data)
          hashes.sort()
          record_hashes = sha.new(''.join(hashes)).hexdigest()
          #:print record_hashes
          imp[key]['hash']= record_hashes

  def _import_stats(self, data, name): #{{{2
      c = self.db.cursor
      if len(data):
          c.execute("insert into data_source_imports (data_source_id, name, created_at, updated_at) values (%s, %s, now(), now())", (self.data_source_id, name))
          c.execute("select last_insert_id()")
          imports_id = c.fetchone()[0]
          inserts = []
          for i in data:
              inserts.append("(%s, %s, now(), now())" % (imports_id, i))
          c.execute("insert into data_source_import_details (data_source_import_id, name_string_id, created_at, updated_at) values %s" % ",".join(inserts))

  def _process_node(self): #{{{2
    if self.reader.NodeType() == 1: #start of a tag
        try:
            tag = self.reader.Name().split(':')[-1]
            ["Simple", "Kingdom", "Rank", "source", "identifier", "GlobalUniqueIdentifier"].index(tag)
            self._current_tag = tag
        except ValueError, e:
            self._current_tag = None
    elif self.reader.NodeType() == 15: #end of a tag
        if self.reader.Name() == "TaxonName":
            self.counter += 1
            if self.counter % 10000 == 0:
              new_time = time.time()
              yield "Processing %sth record. Average Speed: %2d records per second." % (self.counter,self.counter/(new_time - self.time))
            name_string_id = self._prepare_record()
            self._append_imported_data(name_string_id)
            self._record = self._reset_record()
    elif self.reader.NodeType() == 3 and self._current_tag: #text node
        self._record[self._current_tag] = self.reader.Value().strip()
        self._current_tag = None

  def _prepare_record(self): #{{{2
      self.db.cursor.execute("select id from name_strings where name = %s", self._record['Simple'])
      name_string_id = self.db.cursor.fetchone()
      if not name_string_id:
          self.db.cursor.execute("insert into name_strings (name, created_at, updated_at) values (%s, now(), now())", self._record['Simple'])
          self.db.cursor.execute("select last_insert_id()")
          name_string_id = self.db.cursor.fetchone()
      return (name_string_id[0])    
    
  def _append_imported_data(self, name_string_id): #{{{2
    if not self.imported_data.has_key(name_string_id):
        self.imported_data[name_string_id] = {'data': [], 'hash': None}
    try:
      self._record['Kingdom'] = self.kingdoms[self._record['Kingdom'].lower()]
    except KeyError:
      pass
    self.imported_data[name_string_id]['data'].append(self._record.copy())

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
    for ii in i.parse():
      print ii
    print "parsing is done"
    #pp.pprint(i.imported_data)
    #sys.exit()
    i.get_deleted()
    i.get_inserted()
    i.get_changed()
    if (i.deleted or i.inserted or i.changed):
        i.db_delete()
        i.db_insert()
        i.db_update()
        print i.db_store_statistics()
    i.find_overlaps()
    i.db_commit()
