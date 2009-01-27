class NameStringsController < ApplicationController
  layout "application", :except => :details
  
  # GET /name_strings
  # GET /name_strings.xml
  def index
    page = params[:page] || 1
    params[:name_string][:search_term] = params[:name_string][:search_term].strip.gsub(/\*/,'%') unless params[:name_string].nil? || params[:name_string][:search_term].nil?
    if params[:commit] == 'Search Mine'
      @name_strings = NameString.paginate_by_sql(["select n.name from name_strings n join name_indices i on (n.id = i.name_string_id) join data_source_contributors c on (i.data_source_id = c.data_source_id)  where name like ? and c.user_id = ?", params[:name_string][:search_term], current_user.id], :page => page) || nil rescue nil
    else
      @name_strings = NameString.paginate_by_sql(["select * from name_strings where name like ?", params[:name_string][:search_term]], :page => page) || nil rescue nil 
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_strings }
    end
  end

  # GET /name_strings/1
  # GET /name_strings/1.xml
  def show
    @name_string = NameString.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_string }
    end
  end
  
  # GET /name_string/details/1
  def details
    @name_string = NameString.find(params[:id])
    @data_sources_data = @name_string.name_indices.map {|ni| {:data_source => ni.data_source, :records => (NameIndexRecord.find_all_by_name_index_id(ni.id))}}
    respond_to do |format|
      format.html #details.html.haml
    end
  end

end
