class Country < ActiveRecord::Base

  scope :sorted, -> { all.order(:name) }

  validates :name, presence: true

  def small_image
    "assets/16/#{get_image_path}.png"
  end

  def large_image
    "assets/32/#{get_image_path}.png"
  end

  def xl_image
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
