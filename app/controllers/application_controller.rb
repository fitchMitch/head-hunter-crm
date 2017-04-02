class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  def sqlPerc(s)
    '%' + s.to_s + '%'
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Logguez-vous d'abord"
      redirect_to login_url
    end
  end

  def bin_filters(klasses , params)
    if params[:bin_filter]
      filters = params[:bin_filter].split(",")
      query_elems ={}
      filters.each { |fil|
        fil[0] =='-' ? query_elems[fil[1..-1]] = false : query_elems[fil] = true
      }
      query_k = ''
      query_elems.each_key { |key| query_k += key + " = ?," }
      klasses = klasses.where(query_k.chop,query_elems.each_value.to_a)
    else
      klasses
    end
  end

  def reorder(klass_col,params,def_col)
    def_col = def_col || 'name'
    unless klass_col==nil
      if params['sort']
        f = params['sort'].split(',').first
        field = f[0] == '-' ? f[1..-1] : f
        order = f[0] == '-' ? 'DESC' : 'ASC'

        klass_col = klass_col.order("#{field} #{order}")
      else
        klass_col = klass_col.order("#{def_col} ASC")
      end
    end
  end

end
