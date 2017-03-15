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
    res ='<div class="row array_header">'
    parameters['header'].each do |col|
      res += '<div class="col-xs-' + col['width'].to_s+ '"><strong>'
      res +=  col['label'] +'</strong>'
      adj = ''
      unless col['label'].empty?
        sign = parameters['params'][:sort] && parameters['params'][:sort] == "-"+ col['attribute'] ? '' : '-'
        adj = parameters['params'][:sort] && parameters['params'][:sort].first == "-" ? ' <i class="fa fa-sort-amount-desc" aria-hidden="true"></i>' : ' <i class="fa fa-sort-amount-asc" aria-hidden="true"></i>'
        sorting = sign + col['attribute']
        res +=  link_to controller: parameters['tableDB'], sort: sorting, class: "btn" do
          adj.html_safe
        end
      end
      res += '</div>'
    end
    res += '</div>'
    res.html_safe
  end
end
