class UrlCheckController < ApplicationController
  # GET /url_check.xml
  def index
    url2check = params[:url] || ''
    message = GnaUrl::valid_url?(url2check) ? "OK" : "URL is NOT accessible"
    data = {:message => message, :url => url2check}
    respond_to do |format|
      format.xml { render :xml => data.to_xml}
      format.json { render :json => data.to_json }
    end
  end
end
