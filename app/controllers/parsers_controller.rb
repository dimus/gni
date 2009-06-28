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
    format = params[:format] ? params[:format] : 'json'
    names = parser.parse_names_list(names, format)
    if format == 'xml'
      render :xml => names
    elsif format == 'yaml'
      render :text => names
    else
      render :json => json_callback(names, params[:callback])
    end
  end
end