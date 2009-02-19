class Statistic < ActiveRecord::Base
  def self.method_missing(method, *args)
    #TODO refactor to this method when we have more than one statistics parameter
  end

  def self.name_strings_count
    nsc = Statistic.find_by_key('name_strings_count')
    if nsc.blank? || (Time.now - nsc.updated_at > 172800) # 172800 is 48 hours
      new_value = NameString.count.to_s
      nsc ? (nsc.value = new_value; nsc.save) : Statistic.create(:key => 'name_strings_count', :value => new_value)
    end
    nsc.value.to_i
  end

  def self.name_strings_count=(ns_count)
    nsci = Statistic.find_by_key('name_strings_count')
    if nsci
      nsci.value = ns_count.to_s
      nsci.save
    else
      Statistic.create(:key => 'name_strings_count', :value => ns_count.to_s)
    end
  end
end
