# A monkey patch to remove conversion by to_xml names like 'first_name' to 'first-name'
module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:    
    module Hash #:nodoc:
      module Conversions
        #We force :dasherize to be false, since we never want it true.
        #Thanks very much to the reader on the flexiblerails Google Group who
        #suggested this better approach.
        unless method_defined? :old_to_xml
          alias_method :old_to_xml, :to_xml
          def to_xml(options = {})
            options.merge!(:dasherize => false)
            old_to_xml(options)
          end
        end
      end
    end
    module Array #:nodoc:
      module Conversions
        #We force :dasherize to be false, since we never want it true.
        unless method_defined? :old_to_xml
          alias_method :old_to_xml, :to_xml
          def to_xml(options = {})
            options.merge!(:dasherize => false)
            old_to_xml(options)
          end
        end
      end
    end
  end
end
module ActiveRecord #:nodoc:
  module Serialization
    #We force :dasherize to be false, since we never want it true.
    unless method_defined? :old_to_xml
      alias_method :old_to_xml, :to_xml
      def to_xml(options = {})
        options.merge!(:dasherize => false)
        old_to_xml(options)
      end
    end
  end
end
module ActiveRecord #:nodoc:
  class Errors #:nodoc:
    def to_xml_full(options={})
      options[:root] ||= "errors"
      options[:indent] ||= 2
      options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      options[:builder].instruct! unless options.delete(:skip_instruct)
      options[:builder].errors do |e|
        #The @errors instance variable is a Hash inside the Errors class
        @errors.each_key do |attr|
          @errors[attr].each do |msg|
            next if msg.nil?
            if attr == "base"
              options[:builder].error("message"=>msg)
            else
              fullmsg = @base.class.human_attribute_name(attr) + " " + msg
              options[:builder].error("field"=>attr, "message"=>fullmsg)
            end
          end
        end
      end
    end  
  end
end


# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6cf3f472546ba6ae8b0a72276864ba59'


  
protected

  def json_callback(json_struct, callback)
    callback ? callback + "(" + json_struct + ");" : json_struct
  end

  def prepare_search_data()
    d = {}
    d[:page] = params[:page] || 1
    d[:per_page] = (params[:per_page].to_i < 1) ? 30 : params[:per_page].to_i 
    d[:per_page] = PER_PAGE_MAX if d[:per_page] > PER_PAGE_MAX
    #TODO remove last gsub it is jsut to fix crawlers prolem till they switch to new links
    d[:search_term] = params[:search_term].strip.gsub(/\*\s*$/,'%').gsub(/^(HIG%)$/, 'ns:\1') rescue nil
    d[:search_term] = NameString.normalize_name_string(d[:search_term]) if d[:search_term]
    d[:original_search_term] = params[:search_term] || ''
    d[:search_term_errors] = validate_search_term(d[:search_term])
    d[:is_valid_search] = d[:search_term] && d[:search_term_errors].blank?
    if params[:expand] && NameString::LATIN_CHARACTERS.include?(params[:expand].strip)
      d[:char_triples] = NameString.char_triples(params[:expand].strip)
    end
    d
  end

  def validate_search_term(search_term)
    errors = []
    if search_term
      search_term = NameString.prepare_search_term(search_term)
      search_words = search_term.split(" ")
      search_words.each do |sw|
        sw = sw.split(':')
        sw = sw.size > 1 ? sw[-1] : sw[0]
        if sw.include?('%') && sw.size < 4
          errors << 'Search words with whild characters (* or %) should have at leat 3 letters'
          break
        end
      end
    end
    errors
  end
  
  def resource_type
  end
  
  def get_items_number(name_strings)
    item_start = 0
    item_end = 0
    if name_strings && name_strings.size > 0
      item_end = name_strings.current_page * name_strings.per_page
      item_start = item_end - name_strings.per_page + 1
      item_end = name_strings.total_entries if name_strings.current_page == name_strings.total_pages
    end
    item_start = item_end = 1 if name_strings && name_strings.size == 1
    [item_start, item_end]
  end

end
