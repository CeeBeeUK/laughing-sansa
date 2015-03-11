class Country < ActiveRecord::Base

  scope :sorted_by_name, -> { all.order(:name) }

  validates :name, presence: true
  validates :name, uniqueness: true

  def small_image
    "/assets/16/#{return_image_path}.png"
  end

  def large_image
    "/assets/32/#{return_image_path}.png"
  end

  def xl_image
    "/assets/64/#{return_image_path}.png"
  end

  def disabled_image
    "/assets/64/#{return_image_path}_bw.png"
  end

  def to_param
    name
  end

private

  def return_image_path
    name.parameterize.underscore
  end
end
