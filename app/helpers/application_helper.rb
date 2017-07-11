module ApplicationHelper
  def timeago(time, options = {})
    return if time.nil?
    options[:class] ||= 'timeago'
    content_tag(:abbr, time.to_s, options.merge(title: time.getutc.iso8601)) if time
  end
end
