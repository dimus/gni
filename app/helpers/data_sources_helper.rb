module DataSourcesHelper
  
  def link_to_data_source(data_source)
    link = link_to h(data_source.title), data_source
    if data_source.contributor?(current_user)
      return link
    else
      return link_to("Import/Update Data", 
        :url => { :controller => "data_source", :action => 'import', :id => data_source}, 
        :confirm => "Are you sure you want to \n import/update  data from '#{data_source.title}'?") 
    end
  end
  
  def link_to_edit(data_source)
    if data_source.contributor?(current_user)
      return link_to('Edit', edit_data_source_path(data_source))
    else
      return '<span class="disabled_link">Edit</span>'
    end
  end
  
  def link_to_delete(data_source)
    if data_source.contributor?(current_user)
      return link_to('Delete', data_source, :confirm => 'Are you sure?', :method => :delete)
    else
      return '<span class="disabled_link">Delete</span>'
    end
  end
end
