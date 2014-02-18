module DinnersHelper
  def isRequestLinkRequired?(dinner_id, hiker_id)
  	undeclinedRequest = Request.all
  		.where(hiker_id: hiker_id, dinner_id: dinner_id)
  		.where("state != :declined_state", {declined_state: "declined"}).first
  	dinner = Dinner.find(dinner_id)
	#Dinner muss von anderem Hiker sein, in der Zukunft liegen und es darf kein Request vorliegen.
	dinner.hiker_id != hiker_id &&
  	!Request.exists?(undeclinedRequest) && dinner.dinner_end_date > Time.now
  end
end
