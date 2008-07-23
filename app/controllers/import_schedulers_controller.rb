class ImportSchedulersController < ApplicationController

  def create
    @import_scheduler = ImportScheduler.new(params[:import_scheduler])
    respond_to do |format|
      if @import_scheduler.save
        flash[:notice] = "Your data are scheduled for update"
        format.html { redirect_to data_sources_url }
      end
    end
  end
end
