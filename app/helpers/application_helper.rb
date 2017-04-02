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
  def future_time_in_words(t1)
    s = t1.strftime('%s').to_i - Date.today.strftime('%s').to_i

    resolution = if s > 60*60*24*365 # seconds in a year
      ["dans",(s/29030400), 'année']
    elsif s > 60*60*24*30
      ["dans",(s/2419200), 'mois']
    elsif s > 60*60*24*14
      ["dans", (s/604800), 'semaines']
    elsif s > 60*60*24*7
      ['la semaine prochaine']
    elsif s > 60*60*24*3
      ["dans",(s/86400), 'jours']
    elsif s > 60*60*24*2
      ['après demain']
    elsif s > 60*60*24
      ['demain']
    elsif s > 3600 # seconds in an hour
      ["dans",(s/3600), 'heures']
    elsif s > 60
      ["dans",(s/60), 'minutes']
    else
      ["dans quelques secondes"]
    end

    # singular v. plural resolution
    if resolution[0] == 1
      resolution.join(' ')[0...-1]
    else
      resolution.join(' ')
    end
  end

end
