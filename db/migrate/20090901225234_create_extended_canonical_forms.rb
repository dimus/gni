class CreateExtendedCanonicalForms < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE `extended_canonical_forms` (
      `id` int(10) unsigned NOT NULL,
      `number_of_words` smallint(5) unsigned default NULL,
      `word1_id` int(11) default NULL,
      `word1` varchar(100) character set ascii default NULL,
      `word1_length` smallint(3) unsigned default NULL,
      `word2` varchar(100) character set ascii default NULL,
      `word2_length` smallint(3) unsigned default NULL,
      `word3` varchar(100) character set ascii default NULL,
      `word3_length` smallint(3) unsigned default NULL,
      PRIMARY KEY  (`id`),
      KEY `idx_extended_canonical_forms_1` (`number_of_words`),
      KEY `idx_extended_canonical_forms_2` (`word1_id`),
      KEY `word1` (`word1`(1))
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  end

  def self.down
    drop_table :extended_canonical_forms
  end
end
