class NameIndexRecordsController < ApplicationController
  # GET /name_index_records
  # GET /name_index_records.xml
  def index
    @name_index_records = NameIndexRecord.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_index_records }
    end
  end

  # GET /name_index_records/1
  # GET /name_index_records/1.xml
  def show
    @name_index_record = NameIndexRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_index_record }
    end
  end

  # GET /name_index_records/new
  # GET /name_index_records/new.xml
  def new
    @name_index_record = NameIndexRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_index_record }
    end
  end

  # GET /name_index_records/1/edit
  def edit
    @name_index_record = NameIndexRecord.find(params[:id])
  end


  # POST /name_index_records.xml
  def create
    res = GNA_XML::from_tcs(params)
    respond_to do |format|
        format.xml  { render :xml => res.to_xml}
    end

    #@data_source = DataSource.find_by_title(params[:name_index_record][:data_source_title])
    #
    #@name_string = NameString.find_by_name(params[:name_index_record][:name_string])
    #kingdom_id = params[:name_index_record][:kingdom] ? Kindgom.find_by_name(params[:name_index_record][:kingdom]) : nil
    #params[:name_index_record].merge!({:kingdom_id => kingdom_id}) if kingdom_id
    #unless @name_string
    #  @name_string = NameString.create(:name => params[:name_index_record][:name_string])
    #end
    #a = Set.new(['kingdom_id', 'local_id', 'global_id', 'url', 'rank'])
    #b = Set.new(params[:name_index_record].keys)
    #keys = a.intersection(b).to_a.sort
    #
    #pp a
    #pp b
    #pp keys
    #
    #hash_data = keys.map {|k| params[:name_index_record][k]}
    #
    #pp hash_data
    #puts hash_data.to_json
    #
    #hash = Digest::SHA1.hexdigest(hash_data.to_json)
    #
    #puts hash
    #
    #@name_index = NameIndex.create(:name_string_id => @name_string.id, :data_source_id => @data_source.id, :records_hash => hash)
    #
    #[:name_string, :data_source_title].each {|s| params[:name_index_record].delete(s)}
    #@name_index_record = NameIndexRecord.new(params[:name_index_record].merge({:name_index_id => @name_index.id}))

    #respond_to do |format|
    #  if @name_index_record.save
    #    format.xml  { render :xml => @name_index_record, :status => :created, :location => @name_index_record }
    #  else
    #    format.xml  { render :xml => @name_index_record.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # PUT /name_index_records/1
  # PUT /name_index_records/1.xml
  def update
    @name_index_record = NameIndexRecord.find(params[:id])

    respond_to do |format|
      if @name_index_record.update_attributes(params[:name_index_record])
        flash[:notice] = 'NameIndexRecord was successfully updated.'
        format.html { redirect_to(@name_index_record) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_index_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_index_records/1
  # DELETE /name_index_records/1.xml
  def destroy
    @name_index_record = NameIndexRecord.find(params[:id])
    @name_index_record.destroy

    respond_to do |format|
      format.html { redirect_to(name_index_records_url) }
      format.xml  { head :ok }
    end
  end
end
