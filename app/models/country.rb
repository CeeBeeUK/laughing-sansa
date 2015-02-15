class Country < ActiveRecord::Base

  validates :name, presence: true

  def small_image
    "assets/32/#{get_image_path}.png"
  end

  def large_image
    "assets/64/#{get_image_path}.png"
  end


  private

  def get_image_path
    if self.image_path.present?
      self.image_path
    else
      self.name.parameterize.underscore
    end
  end
end
