class StatusController < ApplicationController
  def ping
    render json: {
      build_date: ENV.fetch('BUILD_DATE', 'Not Available'),
      build_tag: ENV.fetch('BUILD_TAG', 'Not Available')
    }
  end
end
