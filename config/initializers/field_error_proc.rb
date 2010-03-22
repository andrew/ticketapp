# this overrides the rails default of wrapping a fieldwitherrors with a div,
# replaces the annoying div with a span instead
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  msg = instance.error_message
  title = msg.kind_of?(Array) ? '* ' + msg.join("\n* ") : msg
  "<span class=\"fieldWithErrors\" title=\"#{title}\">#{html_tag}</span>" 
end