class Hiker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :dinners
	has_many :pictures, as: :imageable
	has_many :incoming_requests, :through => :dinners, :class_name => "Request", :source => :requests
	has_many :outgoing_requests, :class_name => "Request"
	has_many :written_reviews, :class_name => "Review", :foreign_key => "writer_id"
	has_many :received_reviews, :through => :dinners, :source => :reviews
	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "75x75>"}, 
	default_url: "/img/:style/missing.png"
	validates :username, presence: true, uniqueness: { case_sensitive: false}
	scope :attending, -> (dinner) {
		where(id: Request.all.where(state: 'accepted', dinner: dinner).select('hiker_id'))
	}
	scope :creator_of, -> (dinner) {
		where(id: dinner.hiker_id)
	}




end
