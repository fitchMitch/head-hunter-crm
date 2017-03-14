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

  def block_header(header, params, tableDB)
    # @params = params
    #
    # @header=[]
    # @header<<{'width'=>3,'label'=>'Société','attribute'=>'company_name'}
    # @header<<{'width'=>2,'label'=>'','attribute'=>'company_name'}
    # @header<<{'width'=>3,'label'=>'Date d\'enregistrement','attribute'=>'created_at'}
    #
    # @tableDB =  "companies"
    res ='<div class="row array_header">'
    header.each do |col|
      res += '<div class="col-xs-' + col['width'].to_s+ '"><strong>'
      res +=  col['label'] +'</strong>'

      adj = ''
      unless col['label'].empty?
        sign = params[:sort] && params[:sort].first == "-" ? '' : '-'
        adj = params[:sort] && params[:sort].first == "-" ? ' <i class="fa fa-sort-amount-desc" aria-hidden="true"></i>' : ' <i class="fa fa-sort-amount-asc" aria-hidden="true"></i>'
        sorting = sign + col['attribute']
        html_options = {'class' => "btn"}
        res +=  link_to controller: tableDB, sort: sorting, class: "btn" do
          adj.html_safe
        end
      end
      res += '</div>'
    end
    res += '</div>'
    res.html_safe
  end
end
