class NameIndicesController < ApplicationController
  # GET /name_indices
  # GET /name_indices.xml
  def index
    page = params[:page] || 1
    db = ActiveRecord::Base.connection
    @data_source = DataSource.find(params[:data_source_id])
    @search_type = params[:search_type]
    if @search_type = NameIndex::SEARCH_UNIQUE_NAMES
      @page_title = "Unique Names"
      db.execute("create temporary table if not exists 
        name_indices_unique (
          select a.* 
            from name_indices a 
            inner join (
                select name_string_id, 
                  count(*) 
                  from name_indices 
                  group by name_string_id 
                  having count(*) = 2
              ) as b 
            on (a.name_string_id = b.name_string_id) 
            join name_strings ns 
            on (ns.id = a.name_string_id) 
            where data_source_id = #{@data_source.id}
        ) 
        order by ns.name")
      @number_total = NameIndex.find_by_sql("select count(*) as total_count from name_indices_unique")[0].total_count
      @name_strings = NameString.paginate_by_sql("select ns.* from name_indices_unique ni join name_strings ns on ns.id = ni.name_string_id", :page => page)
      @help_info = "#{@number_total} out of total #{@data_source.name_indices.size} names "
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_indices }
    end
  end

  # GET /name_indices/1
  # GET /name_indices/1.xml
  def show
    @name_index = NameIndex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_index }
    end
  end

end
