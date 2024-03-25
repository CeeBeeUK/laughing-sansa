class Country < ApplicationRecord
  # install imagemagick
  # sudo apt-get install imagemagick
  # convert xx.png -colorspace gray xx.png
  # convert ireland.png -resize 16x16 ./../16/ireland.png

  scope :sorted_by_name, -> { all.order(:name) }

  validates :name, presence: true
  validates :name, uniqueness: true

  def small_image
    "16/#{return_image_path}.png"
  end

  def large_image
    "32/#{return_image_path}.png"
  end

  def xl_image
    "64/#{return_image_path}.png"
  end

  def disabled_image
    "64/#{return_image_path}_bw.png"
  end

  def to_param
    name
  end

  private

  def return_image_path
    name.parameterize.underscore
  end
end
