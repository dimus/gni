
def generate_scenario(data)
  data.keys.each do |klass_name|
    klass = Object.const_get(klass_name)
    klass.truncate
    data[klass_name].each do |args|
      klass.gen(args)
    end
  end
end

def downloaded_file(file_name, data_source)
  FileUtils.rm_rf data_source.temporary_path
  FileUtils.rm_rf data_source.directory_path
  FileUtils.mkdir data_source.temporary_path
  FileUtils.cp RAILS_ROOT + '/scenarios/files/' + file_name, data_source.file_path
end
