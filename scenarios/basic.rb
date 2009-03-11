#basic scenario is loaded for the most spec cases

yml_file =  File.join(RAILS_ROOT, 'scenarios', 'yml' , 'basic.yml')
data = YAML.load(ERB.new(open(yml_file).read).result)

data.keys.each do |klass_name|
  klass = Object.const_get(klass_name)
  klass.truncate
  data[klass_name].each do |args|
    klass.gen(args) rescue nil
  end
end

