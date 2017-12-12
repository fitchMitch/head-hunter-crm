module EnumHelper

  def button_filters(sym_klass, enum, selec, css)
    opt = options_for_enum(sym_klass, enum ,selec)
    s = "<select class='#{css}' id='#{sym_klass}_filter_#{enum}' > #{opt}</select>".html_safe
  end

  def options_for_enum(symclass, enum, sel)
    kla = symclass.to_s.camelize #class name from symbol
    options = enums_to_translated_options_array(kla, enum)
    sel_value = kla.classify.safe_constantize.send(enum.pluralize)[sel]
    options_for_select(options, sel_value)
  end

  def enums_to_translated_options_array(klass, enum)
    klass.classify.safe_constantize.send(enum.pluralize).map {
        |key, value| [translate_enum(klass,enum,key), value]
    }
  end

  def translate_enum(klass,enum,key)
    I18n.t("#{klass.downcase}.#{enum}.#{key}")
  end

end
