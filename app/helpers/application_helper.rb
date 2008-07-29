# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_flash
    output = []

    for value in flash[:error]
      output << "<span class=\"error\">#{value}</span>"
    end if flash && flash[:error]
    
    for value in flash[:notice]
      output << "<span class=\"notice\">#{value}</span>"
    end if flash && flash[:notice]
    
    flash[:error] = []
    flash[:notice] = []

    output.join("<br/>\n")
  end

  def data_source_logo(data_source)
    logo_url = data_source.logo_url || "/images/public/empty_logo.png" rescue "/images/public/empty_logo.png"
    result = "<img src=\"#{logo_url}\" class=\"logo\">"
    if data_source.web_site_url && data_source.web_site_url.strip != ""
      result = "<a href=\"#{data_source.web_site_url}\">" + result + "</a>"
    end
    result
  end
end
