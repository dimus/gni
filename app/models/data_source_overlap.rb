class DataSourceOverlap < ActiveRecord::Base
  belongs_to :data_source, :foreign_key => 'data_source_id_1'
  belongs_to :data_source, :foreign_key => 'data_source_id_2'

  def other_data_source
    @other_data_source ||= DataSource.find(data_source_id_2)
  end
  
  def data_source
    @data_source ||= DataSource.find(data_source_id_1)
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
          strict_overlap = c.select_value("
            select count(distinct ni_from.name_string_id)
              from name_indices ni_from 
                join name_indices ni_to 
                  on (ni_from.name_string_id = ni_to.name_string_id) 
              where ni_from.data_source_id = #{dsi1} AND ni_to.data_source_id = #{dsi2}")
          
          lexical_groups_overlap = c.execute("
          (select 
            distinct ni_from.name_string_id 
          from name_indices ni_from 
            join name_indices ni_to 
              on (ni_from.name_string_id = ni_to.name_string_id) 
          where ni_from.data_source_id = #{dsi1} 
          and ni_to.data_source_id = #{dsi2}) 
          
          UNION DISTINCT 
          
          (select 
            distinct(ni_from.name_string_id) 
          from (
            name_indices ni_from 
              join lexical_group_name_strings lgns_from 
                on (ni_from.name_string_id=lgns_from.name_string_id) 
              join lexical_group_name_strings lgns_from_group 
                on (lgns_from.lexical_group_id=lgns_from_group.lexical_group_id)
                ) 
            join (
              name_indices ni_to 
                join lexical_group_name_strings lgns_to 
                  on (ni_to.name_string_id=lgns_to.name_string_id) 
                join lexical_group_name_strings lgns_to_group 
                  on (lgns_to.lexical_group_id=lgns_to_group.lexical_group_id)
                  ) 
              on lgns_from_group.name_string_id=lgns_to_group.name_string_id 
            where ni_from.data_source_id=#{dsi1} and ni_to.data_source_id=#{dsi2})
          ").num_rows
          
          ["data_source_id_2, data_source_id_1","data_source_id_1, data_source_id_2"].each do |t|
            c.execute("
              insert into data_source_overlaps 
                ( #{t}, 
                  strict_overlap, lexical_groups_overlap,
                  created_at, updated_at) 
                values (#{dsi1}, #{dsi2}, #{strict_overlap}, #{lexical_groups_overlap}, now(), now())")
          end
        end
      end
    end
  end

end
