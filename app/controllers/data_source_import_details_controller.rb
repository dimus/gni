class DataSourceImportDetailsController < ApplicationController

  def index
    @data_source_import = DataSourceImport.find(params[:data_source_import_id])
    @data_source = @data_source_import.data_source
    @data = DataSourceImportDetail.paginate_by_sql(["select d.name_string_id from name_strings n join data_source_import_details d on n.id = d.name_string_id where data_source_import_id = ? order by n.name", @data_source_import.id], :page => params[:page])
  end
end
