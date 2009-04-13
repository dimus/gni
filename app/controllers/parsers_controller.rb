class ParsersController < ApplicationController

  # GET /parsers/new
  def new
    render
  end
  
  # POST /parsers
  def create
    names = params[:file].read rescue params[:names] 
    parser = Parser.new
    parser.parse(names)
    #@parsed_names = Hash.from_json(@parsed_names.to_json) 
    if params[:format] == 'json'
      render :json => parser.parsed_names
    elsif params[:format] == 'yaml'
      render :text => parser.parsed_names.to_yaml
    else
      render :xml => parser.to_xml
    end
  end

end