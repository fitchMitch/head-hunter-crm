module PeopleHelper
  def titleList
    %w(M. Mme Mlle )
  end

  def delay_bar(paul)
    # TODO parameter here is hard coded : 3 years
    # puts Date.parse(paul.end_date)
    num = (paul.end_date.jd - paul.start_date.jd)
    step = 3 * 365 / 12 # bar length is full with 12 steps from the grid (and not 12 months) corresponding to 3 years
    i = [(num.abs/step).ceil, 12].min
    str = "<div class='row'> <div class='col-xs-#{i.to_s} grav#{i.to_s}\'></div> </div>"
    str.html_safe
  end

  def years_work(job)
    job.end_date.nil? ? '?' : ((job.end_date.jd - job.start_date.jd) / 365).floor.to_s
  end

  def current_job_part(person)
    job = Job.current_job(person.id) || Job.last_job(person.id)
    t = job.nil? ? '' : "<span class='btn btn-default btn-xs'>#{job.job_title}</span>"
    t.html_safe
  end

  def current_company(person)
    job = Job.current_job(person.id) || Job.last_job(person.id)
    t = job.nil? ? '' : "<span class='redFrame'>#{job.company.company_name}</span>"
    t.html_safe
  end

  def estimated_age(person)
    secs_per_year = 60 * 60 * 24 * 365
    years_shift = (Time.current.to_f - person.updated_at.to_f)/secs_per_year
    person.approx_age + years_shift.round
  end

end
