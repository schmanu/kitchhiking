class Dinner < ActiveRecord::Base
  belongs_to :hiker
  has_many :requests
  has_many :reviews
  has_many :pictures, as: :imageable
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "75x75>"}, 
  default_url: "/img/:style/missing.png"
  validates :hiker, :presence => true
  validates :dinner_start_date, :presence => true
  validates :dinner_end_date, :presence => true
  validates_inclusion_of :active, :in => [true, false]
  scope :active, -> {where(active: true)}
  scope :after, -> (time) { where("dinner_end_date < ?", time)}
  scope :created_by, -> (hiker) {active.where(hiker: hiker)}
  scope :attended_by, -> (hiker) {
    active.where(id: 
          Request.all.where(state: 'accepted', hiker: hiker).select('dinner_id'))
        }

  after_initialize :init_default_values
  def time_left
   #  unit = "minute"
  	# timeleft = (self.dinner_start_date - Time.now).to_i / 1.minute
  	# if timeleft>59
   #    unit = "hour"
  	#   timeleft= timeleft / 60
   #    if timeleft >= 24
   #      unit = "day"
   #      timeleft = timeleft / 24
   #      if timeleft >=7
   #        unit = "week"
   #        timeleft = timeleft / 7
   #        if timeleft >=4
   #          unit = "month"
   #          timeleft = timeleft/4
   #        end
   #      end
   #    end
  	# end

   #  if timeleft > 1
   #    unit = unit+"s"
   #  end

   #  result=timeleft.to_s + " " + unit

    # timediff_string(Time.now, self.dinner_start_date)
  end


  

  def init_default_values
    self.active ||=false
  end
end
