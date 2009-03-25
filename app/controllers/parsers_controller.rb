class ParsersController < ApplicationController
  
  # GET /parsers
  def index
    @names = params[:names]
    @parsed_names = Parser.parse(@names)
    render
  end

  # GET /parsers/new
  def new
    render
  end

end