class Request < ActiveRecord::Base

	STATES = %w{ active declined accepted expired}

	STATES.each do |state|
		define_method("#{state}?") do
			self.state == state
		end

		define_method("#{state}!") do
			self.update_attribute(:state, state)
		end
		
	end


	belongs_to :hiker
	belongs_to :dinner
	has_one :receiver, through: :dinner, source: :hiker
	validate :check_no_selfrequest
	validates :hiker, :presence => true
	validates :dinner, :presence => true
	validates :subject, presence: true
	validates :body, presence: true
	validate :check_state_change

    after_initialize :init_default_values

	def check_no_selfrequest
		errors.add( :receiver, :invalid,
				advice: 
					"You can't send requests to your own events.") if (self.receiver == self.hiker)
	end

	def check_state_change
	#	errors.add(:state, :illegal, 
	#		"Something")
	end

	def init_default_values
		self.state ||=STATES[0]
	end
end
