module PeopleHelper
  def titleList
    %w{M. Mme Mlle}
  end

  def delay_bar(num)
    # TODO parameter here is hard coded : 3 years
    puts num
    step = 3*365 / 12
    i = [(num.abs/step).ceil, 12].min
    str = '<div class="row"> <div class="col-xs-'
    str += i.to_s
    str += ' grav'
    str += i.to_s
    str += '"></div> </div>'
    str.html_safe
  end

end
