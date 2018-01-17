# custom_link_renderer.rb
class CustomLinkRenderer < WillPaginate::ActionView::LinkRenderer

  private

  def symbolized_update(target, other)
    other.each do |key, value|
      # ugly hack requires to use q for ransack queries all along
      key, value = 'q[s]', value['s'] if key == 'q' && !value['s'].nil?
      key = key.to_sym
      existing = target[key]

      if value.is_a?(Hash) && (existing.is_a?(Hash) || existing.nil?)
        symbolized_update(existing || (target[key] = {}), value)
      else
        target[key] = value
      end
    end
  end

end
