class GuidsController < ApplicationController
  # GET /guids
  def index
    if params[:names]
    @names = params[:names].gsub(/[;|]/, "\n")
    @guids = {:uuid_type => 5, :namespace => $GNA_NAMESPACE}
    guids_hash
    @names.each do |name|
      UUID.create_v5(NameString.normalize(name)).guid
    end
  
    respond_to do |format|
      format.html
      format.xml 
      format.json
    end
  end
end
