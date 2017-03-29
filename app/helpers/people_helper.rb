module PeopleHelper
  def titleList
    %w{M. Mme Mlle}
  end

  def delay_bar(num)
    num = (num>0) ? num : -num
    step = 3*365 / 12
    i=12
    (0..12).each do  |j|
      i = 12 - j.to_i
      break if(num > i * step)
    end
    str = '<div class="row"> <div class="col-xs-'
    str += i.to_s
    str += ' grav"></div> </div>'
    str += i.to_s
    str.html_safe
  end

end
