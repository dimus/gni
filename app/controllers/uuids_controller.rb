class UuidsController < ApplicationController

  # GET /parsers
  def index
    names = params[:names] ? params[:names].split(/[;|]/) : []
    names_uuid(names)
  end

  # POST /parsers
  def create
    names = params[:file].read rescue params[:names] 
    names = names ? names.split(/[\n\r]+/) : []
    names_uuid(names)
  end

private 
  def names_uuid(names)
    uuids = []
    names.each do |name|
      name = NameString.normalize_name_string(name)
      uuids << {"name" => name, "uuid" => UUID.create_v5(name, GNA_NAMESPACE).guid}
    end
    format = params[:format] ? params[:format] : 'json'
    if format == 'xml'
      render :xml => uuids
    elsif format == 'yaml'
      render :text => YAML.dump(uuids)
    elsif format == 'json'
      render :json => json_callback(uuids, params[:callback])
    # else
    #   @uuids = uuids
    #   render :action => :uuids
    end
  end
end

