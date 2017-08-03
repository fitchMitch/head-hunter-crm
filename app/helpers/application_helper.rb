module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'JuinJuillet'
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => CustomLinkRenderer
    end
    super *[collection_or_options, options].compact
  end
  #-----------------
  def user_badge(u)
    "<span class=\"badge badge-default\">#{u.trigram}</span>".html_safe
  end
  #-----------------
  def future_time_in_words(t1)
    s = t1.strftime('%s').to_i - Time.zone.now.strftime('%s').to_i
    tomorrow = 60 * 60 * 24
    theDayAfter = tomorrow* 2
    threeDays = tomorrow* 3
    aWeek = tomorrow* 7
    twoWeeks = aWeek* 2
    aMonth = tomorrow* 30
    aYear = tomorrow* 365
    hm = t1.strftime('%Hh%M')

    resolution = if s<0
      s = -s
      if s> aYear # seconds in a year
        ["il y a",(s/aYear), 'année']
      elsif s > aMonth
        ["il y a",(s/aMonth), 'mois']
      elsif s > twoWeeks
        ["il y a", (s/aWeek), 'semaines']
      elsif s > aWeek
        [I18n.t(t1.strftime('%A')), ' dernier à', hm]
      elsif s > threeDays
        [I18n.t(t1.strftime('%A')), ' dernier à', hm]
      elsif s > theDayAfter
        [I18n.t(t1.strftime('%a')), ' hier à ', hm]
      elsif s > tomorrow
        ['hier à', hm]
      elsif s > 3600 # seconds in an hour
        ['il y a',(s/3600), 'heures, à', hm]
      elsif s > 60
        ['depuis', s/36, 'minutes']
      elsif s > 0
        ['il y a secondes']
      else
        ['']
      end
    else
      if s> aYear # seconds in a year
      ['dans',(s/aYear), 'année']
      elsif s > aMonth
        ['dans',(s/aMonth), 'mois']
      elsif s > twoWeeks
        ['dans', (s/aWeek), 'semaines']
      elsif s > aWeek
        [I18n.t(t1.strftime('%A')), ' prochain à', hm]
      elsif s > threeDays
        [I18n.t(t1.strftime('%A')), ' à', hm]
      elsif s > theDayAfter
        [I18n.t(t1.strftime('%a')), ' à', hm]
      elsif s > tomorrow
        ['demain à', hm]
      elsif s > 3600 # seconds in an hour
        ['dans',(s/3600), 'heures, à', hm]
      elsif s > 60
        ['à', hm]
      elsif s > 0
        ['dans quelques secondes']
      else
        ['']
      end
    end

    # singular v. plural resolution
    if resolution[0] == 1
      resolution.join(' ')[0...-1]
    else
      resolution.join(' ')
    end
  end
end
