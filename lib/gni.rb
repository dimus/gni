require 'gni/encoding'
require 'gni/harvester'
require 'gni/image'
require 'gni/name_words_generator'
require 'gni/net'
require 'gni/xml'
require 'gni/parser_result'

module ActiveRecord #:nodoc:
  class Base
    def self.gni_sanitize_sql(ary)
      self.sanitize_sql_array(ary)
    end
  end
end

# A namesplace to keep project-specific data
module GNI  
end