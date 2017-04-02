module PeopleHelper
  def titleList
    %w{M. Mme Mlle}
  end

  def delay_bar(paul)
    # TODO parameter here is hard coded : 3 years
    #puts Date.parse(paul.end_date)
    num = (paul.end_date.jd - paul.start_date.jd)
    step = 3*365 / 12
    i = [(num.abs/step).ceil, 12].min
    str = '<div class="row"> <div class="col-xs-'
    str += i.to_s
    str += ' grav'
    str += i.to_s
    str += '"></div> </div>'
    str.html_safe
  end

  def years_work(job)
    if job.end_date.nil?
      "?"
    else
      dif = ((job.end_date.jd-job.start_date.jd)/365).floor
      dif.to_s
    end
  end

end
