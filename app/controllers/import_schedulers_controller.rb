class ImportSchedulersController < ApplicationController

  def create
    @import_scheduler = ImportScheduler.new(params[:import_scheduler])
    respond_to do |format|
      @import_scheduler.status = params[:import_scheduler][:status].to_i
      if @import_scheduler.save
        spawn do
          system("/Users/dimus/code/gna-ror/script/gni/update_imports")
        end
        flash[:notice] = "Your data are scheduled for update"
        format.html { redirect_to edit_data_source_url(@import_scheduler.data_source_id) }
      end
    end
  end

end
