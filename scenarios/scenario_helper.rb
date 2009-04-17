
def generate_scenario(data)
  data.keys.each do |klass_name|
    klass = Object.const_get(klass_name)
    klass.truncate
    data[klass_name].each do |args|
      klass.gen(args)
    end
  end
end
