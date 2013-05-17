module ApplicationHelper
  # Expand the breadcrumbs from the controller into a breadcrumbs bar
  def show_breadcrumbs
    rval = "<ul class='breadcrumb'>"
    breadcrumbs.each do |x|
      if x[:link].nil?
        rval += x[:title]
      else
        rval += "<li><a href='#{x[:link]}'>#{x[:title]}</a>"
        rval += "<span class='divider'>/</span>" if rval.length > 23
				rval += "</li>"
      end
    end
    rval += "</ul>"
    rval.html_safe
  end

  # Create a field/value combination that can be styled
  def labeled_field(label, value)
		("<dt>#{label}</dt> <dd>#{value}</dd>").html_safe
  end

  def getAgeText(birthdate)
      return "Forever Young"     if birthdate.nil?
    
    bdate = Time.at(birthdate) if (birthdate.class == Fixnum) 
    return date(bdate) + "&nbsp;(" + time_ago_in_words(bdate) + " old)"
  end

  # Show the date, formatted
  def date(date_value, default = 'never')
    if date_value
      date_value = Time.at(date_value) if date_value.class == Fixnum
      date_value.strftime("%d-%b-%Y")
    else
      default
    end
  end
end
