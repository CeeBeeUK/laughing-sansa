class Country < ActiveRecord::Base

  scope :sorted_by_name, -> { all.order(:name) }

  validates :name, presence: true
  validates :name, uniqueness: true
  
  def small_image
    "/assets/16/#{get_image_path}.png"
  end

  def large_image
    "/assets/32/#{get_image_path}.png"
  end

  def xl_image
    "/assets/64/#{get_image_path}.png"
  end

  def disabled_image
    "/assets/64/#{get_image_path}_bw.png"
  end
  
  def to_param
    self.name
  end

private

  def get_image_path
    self.name.parameterize.underscore
  end
end
