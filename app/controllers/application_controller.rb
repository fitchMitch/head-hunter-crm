class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  def sql_perc(s)
    '%' + s.to_s + '%'
  end

  def logged_in_user
    return false if logged_in?
    store_location
    flash[ :danger] = 'Logguez-vous d\'abord'
    redirect_to login_url
  end

  def bin_filters(klasses, params)
    return klasses if params[ :bin_filter].nil?
    query_elems = {}
    #query_elems = params[ :filter].nil? ? {} :  { 'filter' => params[ :filter]}
    bin_filter = params[ :bin_filter].split(",")
    bin_filter.each do |fil|
      fil[0] == '-' ? query_elems[fil[1..-1]] = false : query_elems[fil] = true
    end
    query_k = ''
    query_elems.each_key { |key| query_k += key + " = ?," }
    klasses.where(query_k.chop, query_elems.each_value.to_a)
  end

  def reorder(klass_col, params, def_col)
    return if klass_col.nil?
    def_col ||= 'name'
    if params['sort']
      f = params['sort'].split(', ').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'

      klass_col = klass_col.order("#{field} #{order}")
    else
      klass_col = klass_col.order("#{def_col} ASC")
    end
  end
end
