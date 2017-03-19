class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def sqlPerc(s)
    '%' + s.to_s + '%'
  end
  
end
