class ImportSchedulersController < ApplicationController

  def show
    @import_scheduler = ImportScheduler.find(params[:id])
    respond_to do |format|
      format.xml {render :xml => @import_scheduler.to_xml}
      format.json {render :json => @import_scheduler.to_json}
    end
  end
  
  def create
    unless ImportScheduler.scheduled? params[:import_scheduler][:data_source_id]
      @import_scheduler = ImportScheduler.new(params[:import_scheduler])
      respond_to do |format|
        @import_scheduler.status = params[:import_scheduler][:status].to_i
        
        if @import_scheduler.save
          spawn do
            dir = File.dirname(__FILE__) + "/../../script/gni/update_imports -e " + ENV['RAILS_ENV'] 
            system(dir)
          end
          flash[:notice] = "Your data are scheduled for update"
          format.html { redirect_to data_source_url(@import_scheduler.data_source_id) }
        end
      end
    end
  end

end
