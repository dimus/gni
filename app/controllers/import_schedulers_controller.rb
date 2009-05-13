class ImportSchedulersController < ApplicationController
  
  def index
    data_sources_scheduled = ImportScheduler.run_scheduler(true) #dry run
    respond_to do |format|
      format.xml {render :xml => data_sources_scheduled.to_xml}
      format.json {render :json => data_sources_scheduled.to_json}
    end
  end

  def show
    @import_scheduler = ImportScheduler.find(params[:id])
    respond_to do |format|
      format.xml {render :xml => @import_scheduler.to_xml}
      format.json {render :json => @import_scheduler.to_json}
    end
  end
  
  def create
    unless ImportScheduler.in_process? params[:import_scheduler][:data_source_id]
      @import_scheduler = ImportScheduler.new(params[:import_scheduler])
      respond_to do |format|
        @import_scheduler.status = params[:import_scheduler][:status].to_i
        
        if @import_scheduler.save
          spawn do
            dir = RAILS_ROOT + "/script/gni/downloader.rb -e " + ENV['RAILS_ENV'] 
            system(dir)
          end
          flash[:notice] = "Your data are scheduled for update"
          format.html { redirect_to data_source_url(@import_scheduler.data_source_id) }
        end
      end
    end
  end

end
