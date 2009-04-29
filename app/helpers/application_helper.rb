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
  
  def format_guid(guid)
    lsid = /^urn:lsid:.*$/
    guid = lsid.match(guid) ? link_to(guid, 'http://lsid.tdwg.org/summary/' + guid) : guid
  end
  
  def format_date(date,format='%m/%d/%y')
    date.strftime(format)
  end
  
  def dates_interval(date1, date2)
    raise ArgumentError, "#{format_date(date1)} is bigger than #{format_date(date2)}" if date1 > date2
    date_string = format_date(date1) + " - "
    if date1.year == date2.year
      date_string += format_date(date2, '%m/%d')
    else
      date_string += format_date(date2)
    end
    date_string
  end

  def data_source_logo(data_source)
    default_logo = "/images/public/empty_logo.png"
    logo_url = (data_source.logo_url && !data_source.logo_url.empty?) ? data_source.logo_url : default_logo
    result = "<img src=\"#{logo_url}\" class=\"logo\"/>"
    result = "<a href=\"#{data_source_url(data_source.id)}\">" + result + "</a>"
    result
  end

  def in_quotes(a_string)
    "&ldquo;" + a_string + "&rdquo;"
  end
  
  def display_big_int(an_int)
    an_int.to_s.reverse.gsub(/([\d]{3})/,'\1,').reverse.gsub(/^[\s,]*/,'')
  end
  
end
