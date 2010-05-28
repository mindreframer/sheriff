module ApplicationHelper
  def nested_layout(layout, &block)
    @content_for_layout = capture(&block)
    concat(render(:file => layout))
  end
end
