class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  def sqlPerc(s)
    '%' + s.to_s + '%'
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

end
