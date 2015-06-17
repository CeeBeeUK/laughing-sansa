require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'timeago' do
    it 'renders an abbr' do
      Time.zone = 'UTC'
      start = Time.zone.local(2015, 5, 5, 12, 30)
      expected = "<abbr class=\"timeago\" title=\"#{start.getutc.iso8601}\">#{start}</abbr>"
      expect(helper.timeago(start)).to eql(expected)
    end
  end
end
