class ParsersController < ApplicationController

  # GET /parsers
  def index
    names = params[:names].gsub(";","\n")
    parse_names(names)
  end

  # GET /parsers/new
  def new
  end
  
  # POST /parsers
  def create
    names = params[:file].read rescue params[:names] 
    parse_names(names)
  end

private 
  def parse_names(names)
    parser = Parser.new
    parser.parse(names)
    #@parsed_names = Hash.from_json(@parsed_names.to_json) 
    if params[:format] == 'json'
      render :json => json_callback(parser.parsed_names.to_json, params[:callback])
    elsif params[:format] == 'yaml'
      render :text => parser.parsed_names.to_yaml
    else
      render :xml => parser.to_xml
    end
  end
end