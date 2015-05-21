require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'timeago' do
    it 'renders an abbr' do
      start = DateTime.new(2015, 5, 5, 12, 30).to_time
      expected = "<abbr class=\"timeago\" title=\"#{start.getutc.iso8601}\">#{start}</abbr>"
      expect(helper.timeago(start)).to eql(expected)
    end
  end
end
