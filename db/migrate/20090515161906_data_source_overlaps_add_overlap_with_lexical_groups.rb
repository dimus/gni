class DataSourceOverlapsAddOverlapWithLexicalGroups < ActiveRecord::Migration
  def self.up
    add_column :data_source_overlaps, :lexical_groups_overlap, :integer
  end

  def self.down
    remove_column :data_source_overlaps, :lexical_groups_overlap
  end
end
