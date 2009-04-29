class DataSourceOverlap < ActiveRecord::Base
  belongs_to :data_source, :foreign_key => 'data_source_id_1'
  belongs_to :data_source, :foreign_key => 'data_source_id_2'

  def other_data_source
    @other_data_source ||= DataSource.find(data_source_id_2)
  end

  def self.find_all_overlaps()
    c = ActiveRecord::Base.connection
    c.transaction do
      c.execute("truncate data_source_overlaps")
      data_source_ids1 = c.select_values('select id from data_sources order by id')
      data_source_ids2 = data_source_ids1.dup
      data_source_ids1.each do |dsi1|
        data_source_ids2.shift #remove id we work with
        data_source_ids2.each do |dsi2|
          overlap = c.select_value("
            select count(distinct ni_from.name_string_id)
              from name_indices ni_from 
                join name_indices ni_to 
                  on (ni_from.name_string_id = ni_to.name_string_id) 
              where ni_from.data_source_id = #{dsi1} AND ni_to.data_source_id = #{dsi2}")
          ["data_source_id_2, data_source_id_1","data_source_id_1, data_source_id_2"].each do |t|
            c.execute("
              insert into data_source_overlaps 
                ( #{t}, 
                  strict_overlap, 
                  created_at, updated_at) 
                values (#{dsi1}, #{dsi2}, #{overlap}, now(), now())")
          end
        end
      end
    end
  end

end
