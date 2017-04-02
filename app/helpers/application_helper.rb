module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "JuinJuillet"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def block_header(parameters)
    # Example
    # @parameters = {'params'=> params, 'header' => [],'tableDB'=> "companies"}
    # @parameters['header']<<{'width'=>3,'label'=>'Société','attribute'=>'company_name'}
    # @parameters['header']<<{'width'=>2,'label'=>'','attribute'=>'company_name'}
    # @parameters['header']<<{'width'=>3,'label'=>'Date d\'enregistrement','attribute'=>'created_at'}
    sort = parameters['params'][:sort]
    res ='<div class="row array_header">'
    parameters['header'].each do |col|
      res += '<div class="col-xs-' + col['width'].to_s+ '">'
      unless col['label'].empty?
        res +=  '<strong>' + col['label'] +'</strong>'
        unless col['attribute'] == 'none'
          sorting=''
          if sort == col['attribute']
            adj =  ' <i class="fa fa-sort-amount-desc" aria-hidden="true"></i>'
            sorting = "-" +  col['attribute']
          # created_at should make exception
          else
            adj =  ' <i class="fa fa-sort-amount-asc" aria-hidden="true"></i>'
            sorting =  col['attribute']
          end
          if parameters['params'][:bin_filter] == nil
            res +=  link_to controller: parameters['tableDB'], sort: sorting  do
              adj.html_safe
            end
          else
            res +=  link_to controller: parameters['tableDB'], sort: sorting ,bin_filter: parameters['params']['bin_filter'] do
              adj.html_safe
            end
          end
        end
      end
      res += '</div>'
    end
    res += '</div>'
    res.html_safe
  end
  #-----------------
  def active_classes(attr,val)
      request.query_parameters['bin_filter'] = val== 1 ? attr : "-" + attr
      request.query_parameters['page']=1
      request.query_parameters
  end
  #-----------------
  def user_badge(u)
    str = '<span class="badge badge-default">' + u.trigram + '</span>'
    str.html_safe
  end
  #-----------------
  def future_time_in_words(t1)
    s = t1.strftime('%s').to_i - Time.zone.now.strftime('%s').to_i
    tomorrow = 60*60*24
    theDayAfter = tomorrow*2
    threeDays = tomorrow*3
    aWeek = tomorrow*7
    twoWeeks = aWeek*2
    aMonth = tomorrow*30
    aYear = tomorrow*365
    hm = t1.strftime('%Hh%M')

    resolution = if s<0
      ['passé']
    elsif s> aYear # seconds in a year
      ["dans",(s/aYear), 'année']
    elsif s > aMonth
      ["dans",(s/aMonth), 'mois']
    elsif s > twoWeeks
      ["dans", (s/aWeek), 'semaines']
    elsif s > aWeek
      ['la semaine prochaine']
    elsif s > threeDays
      ["dans",(s/tomorrow), 'jours']
    elsif s > theDayAfter
      [t1.strftime('%a à'),hm]
    elsif s > tomorrow
      ['demain à',hm]
    elsif s > 3600 # seconds in an hour
      ["dans",(s/3600), 'heures, à',hm]
    elsif s > 60
      ["à",hm]
    elsif s > 0
      ["dans quelques secondes"]
    else
      [""]
    end

    # singular v. plural resolution
    if resolution[0] == 1
      resolution.join(' ')[0...-1]
    else
      resolution.join(' ')
    end
  end

end
