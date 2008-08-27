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
    default_logo = "/images/public/empty_logo.png"
    logo_url = (data_source.logo_url && !data_source.logo_url.empty?) ? data_source.logo_url : default_logo
    result = "<img src=\"#{logo_url}\" class=\"logo\">"
    result = "<a href=\"#{data_source_url(data_source.id)}\">" + result + "</a>"
    result
  end

  def in_quotes(a_string)
    "&ldquo;" + a_string + "&rdquo;"
  end
end
