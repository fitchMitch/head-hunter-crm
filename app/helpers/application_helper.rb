module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = I18n.t('brand')
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge renderer: CustomLinkRenderer
    end
    super *[collection_or_options, options].compact
  end

  def user_badge(u)
    "<span class=\"badge badge-default\">#{u.trigram}</span>".html_safe
  end

  def search_hash_key(thisHash,value)
    thisHash.select { |_, v| v == value.to_sym }.keys
  end

  def future_time_in_words(t1)
    s = t1.strftime('%s').to_i - Time.zone.now.strftime('%s').to_i
    tomorrow = 60 * 60 * 24
    the_day_after = tomorrow * 2
    three_days = tomorrow * 3
    a_week = tomorrow * 7
    twoWeeks = a_week * 2
    a_month = tomorrow * 30
    a_year = tomorrow * 365
    hm = t1.strftime('%Hh%M')

    resolution = if s < 0
      s = -s
      if s > a_year # seconds in a year
        ['il y a', s / a_year, 'année']
      elsif s > a_month
        ['il y a', s / a_month, 'mois']
      elsif s > twoWeeks
        ['il y a', s / a_week, 'semaines']
      elsif s > a_week
        [I18n.t(t1.strftime('%A')), ' dernier à', hm]
      elsif s > three_days
        [I18n.t(t1.strftime('%A')), ' dernier à', hm]
      elsif s > the_day_after
        [I18n.t(t1.strftime('%a')), 'hier à ', hm]
      elsif s > tomorrow
        ['hier à', hm]
      elsif s > 3600 # seconds in an hour
        ['il y a', s / 3600, 'heures, à', hm]
      elsif s > 60
        ['depuis', s / 36, 'minutes']
      elsif s > 0
        ['il y a', s, 'secondes']
      else
        ['']
      end
    else
      if s > a_year # seconds in a year
      ['dans', s / a_year, 'année']
      elsif s > a_month
        ['dans', s / a_month, 'mois']
      elsif s > twoWeeks
        ['dans', s / a_week, 'semaines']
      elsif s > a_week
        [I18n.t(t1.strftime('%A')), ' en huit à', hm]
      elsif s > three_days
        [I18n.t(t1.strftime('%A')), ' à', hm]
      elsif s > the_day_after
        [I18n.t(t1.strftime('%a')), ' à', hm]
      elsif s > tomorrow
        ['demain à', hm]
      elsif s > 3600 # seconds in an hour
        ['dans', s/3600, 'heures, à', hm]
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
