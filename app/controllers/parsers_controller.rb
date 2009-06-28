class ParsersController < ApplicationController

  # GET /parsers
  def index
    names = params[:names].gsub(/[;|]/,"\n")
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
    parser.parse_names_list_to_json(names)
    #@parsed_names = Hash.from_json(@parsed_names.to_json) 
    if params[:format] == 'xml'
      render :xml => parser.to_xml
    elsif params[:format] == 'yaml'
      render :text => parser.parsed_names.to_yaml
    else
      render :json => json_callback(parser.parsed_names.to_json, params[:callback])
    end
  end
end