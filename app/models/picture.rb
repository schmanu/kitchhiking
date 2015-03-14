class Picture < ActiveRecord::Base
    belongs_to :imageable, polymorphic: true
    has_attached_file :image, styles: { medium: "300x300>", thumb: "75x75>"}, 
      default_url: "/img/:style/missing.png"
end
