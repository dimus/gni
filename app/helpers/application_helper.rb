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
  
  def format_date(date,format='%d-%m-%Y')
    date.strftime(format)
  end
  
  def dates_interval(date1, date2)
    raise ArgumentError, "#{format_date(date1)} is bigger than #{format_date(date2)}" if date1 > date2
    date_string = format_date(date1) + " - "
    if date1.year == date2.year
      date_string += format_date(date2, '%d-%m')
    else
      date_string += format_date(date2)
    end
    date_string
  end

  def data_source_logo(data_source, size='medium')
    default_logo = "/images/logos/default_" + size + ".jpg"
    ds_logo = "/images/logos/" + data_source.id.to_s + "_" + size + ".jpg"
    logo_url = File.exists?(RAILS_ROOT + "/public" + ds_logo) ? ds_logo : default_logo
    result = "<img src=\"#{logo_url}\"/>"
    "<a href=\"#{data_source_url(data_source.id)}\">" + result + "</a>"
  end

  def in_quotes(a_string)
    "&ldquo;" + a_string + "&rdquo;"
  end
  
  def display_big_int(an_int)
    an_int.to_s.reverse.gsub(/([\d]{3})/,'\1,').reverse.gsub(/^[\s,]*/,'')
  end
  
  def chart_overlap(data_source_overlap, type='strict')
      data_source_overlap = data_source_overlap[0..10]
      percentage = data_source_overlap.map {|d| type == 'strict' ? d.strict_percentage : d.lexical_groups_percentage}.join(',')
      ceiling = data_source_overlap.map {|d| 100}.join(',')
      titles = data_source_overlap.map {|d| shorten_string(d.other_data_source.title,20)}.reverse.join('|')
      chart = '<img src="http://chart.apis.google.com/chart?cht=bhs'
      chart += "&amp;chs=400x#{24 * data_source_overlap.size + 25}"
      chart += "&amp;chd=t:#{percentage}|#{ceiling}"
      chart += '&amp;chco=45704d,cbe4c3&amp;chbh=20'
      chart += '&amp;chxt=x,y'
      chart += "&amp;chxl=0:|0|25|50|75|100|1:|#{titles}|"
      chart += '">'
  end
  
  def shorten_string (string, count = 30)
    if string.length >= count 
      shortened = string[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words-1].join(" ") + ' ...'
    else 
      string
    end
  end
  
  
end
