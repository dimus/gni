class ImportSchedulersController < ApplicationController

  def create
    @import_scheduler = ImportScheduler.new(params[:import_scheduler])
    respond_to do |format|
      @import_scheduler.status = params[:import_scheduler][:status].to_i
      if @import_scheduler.save
        spawn do
          puts 'work dddd'
          system("/Users/dimus/code/gna-ror/script/gni/update_imports")
        end
        flash[:notice] = "Your data are scheduled for update"
        format.html { redirect_to data_sources_url }
      end
    end
  end
end
