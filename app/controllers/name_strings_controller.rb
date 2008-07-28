class NameStringsController < ApplicationController
  # GET /name_strings
  # GET /name_strings.xml
  def index
    page = params[:page] || 1
    #name = params[:name_string][:name] && params[:name_string][:name].strip != "" ? params[:name_string][:name] : '#$@#@#$#@^%#$@DFSJLFKJSFDSDLKJ' 
    @name_strings = NameString.paginate_by_sql(["select * from name_strings where name like ?", params[:name_string][:name] + '%'], :page => page) || nil rescue nil 
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

end
