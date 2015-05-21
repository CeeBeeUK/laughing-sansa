require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'timeago' do
    it 'renders an abbr' do
      display = DateTime.new(2015, 5, 5, 12, 30).utc.to_time
      expected = '<abbr class="timeago" title="2015-05-05T12:30:00Z">2015-05-05 13:30:00 +0100</abbr>'
      expect(helper.timeago(display)).to eql(expected)
    end
  end
end
