class Review < ActiveRecord::Base
	belongs_to :writer, :class_name => "Hiker"
	belongs_to :dinner 
	has_one :receiver, :through => :dinner, source: :hiker
	validate :validate_review 
	validates :writer, :presence => true
	validates :dinner, :presence => true

	def validate_review
		errors.add(:receiver, :invalid, advice: "You cant send a review to yourself") if (self.receiver == self.writer)
		if !self.dinner.nil? && !self.dinner.dinner_end_date.nil?
			errors.add(:dinner, :invalid, advice: "You can't review a dinner before it takes place") if ((self.updated_at.nil? && self.dinner.dinner_end_date > DateTime.now) || (!self.updated_at.nil? && self.updated_at < self.dinner.dinner_end_date))
		end	
    if !self.writer.nil? && !self.dinner.nil?
				corresponding_request = self.writer.outgoing_requests.order("created_at DESC").find_by(dinner: self.dinner)
				errors.add(:dinner, :invalid, advice: "Cannot find a matching request for dinner.") if corresponding_request.nil? 
        if !corresponding_request.nil?
          errors.add(:dinner, :invalid, advice: "Your request did not get accepted.") if  !corresponding_request.accepted?
        end
		end
	end

	
end
