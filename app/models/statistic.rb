class Statistic < ActiveRecord::Base

  def self.name_strings_count
    nsc = Statistic.find_by_stat_key('name_strings_count')
    if nsc.blank? # || (Time.now - nsc.updated_at > 172800) # 172800 is 48 hours
      new_value = NameString.count.to_s
      nsc ? (nsc.stat_value = new_value; nsc.save) : nsc = Statistic.create(:stat_key => 'name_strings_count', :stat_value => new_value)
    end
    nsc.stat_value.to_i
  end

  def self.name_strings_count=(ns_count)
    nsci = Statistic.find_by_stat_key('name_strings_count')
    if nsci
      nsci.stat_value = ns_count.to_s
      nsci.save
    else
      Statistic.create(:stat_key => 'name_strings_count', :stat_value => ns_count.to_s)
    end
  end
end
