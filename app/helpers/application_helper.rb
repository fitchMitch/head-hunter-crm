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
      options = collection_or_options
      collection_or_options = nil
    end
    unless options[:renderer]
      options = options.merge renderer: CustomLinkRenderer
    end
    super *[collection_or_options, options].compact
  end

  def user_badge(u)
    "<span class=\"badge badge-default\">#{u.trigram}</span>".html_safe
  end

  def search_hash_key(thisHash, value)
    thisHash.select { |_, v| v == value.to_sym }.keys
  end

  def future_time_in_words(t1)

    def which_key(time_steps, time_data)
      return :seconde if time_data[:s].zero?
      triggers = time_steps.values.sort.reverse
      best_level = (triggers.select { |trigger| trigger < time_data[:s]}).sort.last
      time_steps.key best_level
    end

    def say_it(time_steps, level, time_data)
      triggers = time_steps.values.sort.reverse
      wording_for_future = {
        a_year:       ['dans nr années','a_year'],
        a_month:      ['dans nr mois','a_month'],
        two_weeks:    ['dans nr semaines','a_week'],
        a_week:       ['dayz en huit', 'null'],
        the_day_after:[ 'dayz prochain', 'null'],
        tomorrow:     ['demain, à hour h', 'hour'],
        hour:         ['à hour h', 'hour'],
        minute:       ['dans nr minute', 'minute'],
        seconde:      ['dans quelques secondes', 'null']
      }
      wording_for_past = {
        a_year:       ['il y a nr années','a_year'],
        a_month:      ['il y a nr mois', 'a_month'],
        two_weeks:    ['il y a nr semaines', 'a_week'],
        a_week:       ['il y a plus de nr semaine', 'a_week'],
        the_day_after:[ 'dayz dernier, à hour h', 'hour'],
        tomorrow:     ['hier, à hour h', 'hour'],
        hour:         ['hier, à hour h', 'hour'],
        minute:       ['il y a minute min', 'minute'],
        seconde:      ['il y a quelques secondes', 'null']
      }


      lexico = (time_data[:direction] == 'past') ? wording_for_past : wording_for_future
      wording = lexico[level][0]
      unit = lexico[level][1].to_sym
      wording = wording.sub(/nr/, (time_data[:s] / time_steps[unit]).to_i.to_s) unless unit == :null
      wording = wording.sub(/dayz/, I18n.t(time_data[:t1].strftime('%A')))
      wording = wording.sub(/hour/, time_data[:t1].strftime('%HhM'))
      wording = wording.sub(/minute/, time_data[:t1].strftime('%M'))
    end

    time_steps = {
      null: 0,
      seconde: 1,
      minute: 60,
      hour: 60 * 60,
      tomorrow: 24 * 60 * 60,
      the_day_after: 2 * 24 * 60 * 60,
      a_week: 7 * 24 * 60 * 60,
      two_weeks: 2 * 7 * 24 * 60 * 60,
      a_month: 30 * 24 * 60 * 60,
      a_year: 365 * 24 * 60 * 60
    }
    s = t1.strftime('%s').to_i - Time.zone.now.strftime('%s').to_i
    time_data = {s: s, t1: t1, direction: 'past'}

    if s < 0
      time_data[:s] = -time_data[:s]
    else
      time_data[:direction] = 'future'
    end
    level = which_key(time_steps, time_data)
    say_it(time_steps, level, time_data)
  end
end
