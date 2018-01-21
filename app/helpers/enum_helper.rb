module EnumHelper
  def button_filters(rand_params, empty_option = true)
    opt = options_for_enum(rand_params, empty_option)
    s = "<select class='#{rand_params['css']}'
      id='#{rand_params['sym_klass']}_filter_#{rand_params['enum']}'>
      #{opt}</select>".html_safe
  end

  def button_filters_with_ransack(rand_params, empty_option = true)
    opt = options_for_enum(
      rand_params['sym_klass'],
      rand_params['enum'],
      rand_params['selec'],
      empty_option
    )
    s = "<select class='#{rand_params['css']}'
      id='#{rand_params['id']}'
      name='#{rand_params['name']}'>
      #{opt}
      </select>".html_safe
  end

  def options_for_enum(symclass, enum, selec, empty_option)
    klass = symclass.to_s.camelize # class name from symbol
    options = enums_to_translated_options_array(klass, enum)
    options = [['', '']] + options if empty_option

    sel_value = selec.scan(/\D/).empty? ?
                    selec.to_i
                    :
                    klass.classify.safe_constantize.send(enum.pluralize)[selec.to_sym]

    options_for_select(options, sel_value)
  end

  def enums_to_translated_options_array(klass, enum)
    klass.classify.safe_constantize.send(enum.pluralize).map do |key, value|
      [translate_enum(klass, enum, key), value]
    end
  end

  def translate_enum(klass, enum, key)
    I18n.t("#{klass.downcase}.#{enum}.#{key}")
  end
end
