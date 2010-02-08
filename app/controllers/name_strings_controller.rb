class NameStringsController < ApplicationController
  layout "application", :except => :show
  
  # GET /name_strings
  # GET /name_strings.xml
  def index
    
    search_data = prepare_search_data
    @search_term = search_data[:original_search_term]
    @char_triples = search_data[:char_triples]

    @show_help = !!params[:help]
    @names_total = Statistic.name_strings_count
    
    if search_data[:is_valid_search]
      search_term = NameString.normalize_name_string(search_data[:search_term])
      if params[:commit] == 'Search Mine'
        @name_strings = NameString.search(search_term, nil, current_user.id, search_data[:page], search_data[:per_page])
      elsif params[:data_source_id]
        search_term ||= '%'
        @name_strings = NameString.search(search_term, params[:data_source_id], nil, search_data[:page], search_data[:per_page])
      else
        @name_strings = NameString.search(search_term, nil, nil, search_data[:page], search_data[:per_page]) 
      end
    else
      #returning Pagintation object instead of empty array
      @name_strings = NameString.paginate_by_sql("select 1 from name_strings where 1=2", :page => page, :per_page => search_data[:per_page]) || nil rescue nil 
      flash[:error]=search_data[:search_term_errors]
    end
    
    @empty_search = (search_data[:is_valid_search] && @name_strings.blank?)
    
    if params[:expand] && NameString::LATIN_CHARACTERS.include?(params[:expand].strip)
      @char_triples = NameString.char_triples(params[:expand].strip)
    end
    
    @item_first, @item_last = get_items_number(@name_strings)
    
    #TODO UGGGLY!!!
    @name_strings_serialized = @name_strings.map {|ns| ns.resource_uri = name_string_url(ns.id)+".xml"; Hash.from_xml(ns.to_xml :except => [:uuid], :methods => [:resource_uri, :uuid_hex, :lsid])['name_string']} unless @name_strings.blank?
    result = {}
    result[:page_number] = search_data[:page]
    result[:name_strings_total] = @name_strings.total_entries rescue nil
    #result[:total_pages] = (result[:name_strings_total]/(per_page.to_f)).ceil rescue 0
    result[:per_page] = search_data[:per_page]
    result[:next_page] = name_strings_url(:search_term => search_data[:original_search_term], :per_page => search_data[:per_page], :page => page.to_i + 1, :format=>:xml) unless result[:total_pages].to_i <= search_data[:page].to_i
    result[:name_strings] = @name_strings_serialized
    
    respond_to do |format|
        format.html # index.html.erb
        format.xml {render :xml => result}
        format.json {render :json => json_callback(result.to_json,params[:callback])}
    end
  end

  # GET /name_strings/1
  # GET /name_strings/1.xml
  def show
    @name_string = NameString.find(params[:id])
    @show_records = (params[:all_records] && params[:all_records] != '0') ? true : false
    @parsed_name = Parser.new.parse(@name_string.name)
    @data_sources_data = @name_string.name_indices.map do |ni| 
      res = {:name_index_id => ni.id, :data_source => ni.data_source, :records_number => ni.name_index_records.size}
      res.merge!(:records =>  (NameIndexRecord.find_all_by_name_index_id(ni.id))) if @show_records
      res
    end
    data = {:data => @data_sources_data, :name_string => @name_string}
    respond_to do |format|
      format.html
      format.xml {render :xml => data.to_xml(:except => [:uuid], :methods => [:uuid_hex, :lsid, :resource_uri])}
      format.json {render :json => json_callback(data.to_json,params[:callback])}
    end
  end
  
  # explanation what the site is about
  def about
  end

end
