class ApiController < ApplicationController

  def index
    @api_links = [
      {:link => name_strings_url + ".xml", :parameters => [{:parameter=>"search_term"}, {:parameter=>"per_page"}], :description => "Name search"},
      {:link => name_strings_url + "/2.xml", :description => "Details about a given name"}
    ]
    respond_to do |format|
      format.html
      format.xml {render :xml => @api_links} 
    end
  end

end
