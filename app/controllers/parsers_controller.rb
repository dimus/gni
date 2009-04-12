class ParsersController < ApplicationController

  # GET /parsers/new
  def new
    render
  end
  
  # POST /parsers
  def create
    @names = params[:file].read rescue params[:names] 
    @parsed_names = Parser.parse(@names)
    if params[:format] == 'json'
      render :json => @parsed_names
    else
      render :xml => @parsed_names
    end
  end

end