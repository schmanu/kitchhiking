class HomeController < ApplicationController
  def index
  	@hiker = Hiker.new
  	if session[:errors]
  		session[:errors].each {|error, error_message| @hiker.errors.add error, error_message}
  		session.delete :errors
  	end
  	if hiker_signed_in?
      @incoming_requests = Request.all.where(state: 'active', dinner_id: Dinner.all.where(hiker: current_hiker)).order('created_at').reverse_order
      @outgoing_requests = Request.all.where(state: 'active', hiker: current_hiker).order('created_at').reverse_order
      @nearby_dinners = Dinner.all
        .where("hiker_id != :current_hiker", {current_hiker: current_hiker})
        .where(active: true)
        .where("dinner_start_date > :current_date", {current_date: Time.now})
        .order("dinner_start_date")
      @upcoming_dinners = Dinner.created_by(current_hiker)
        .where("dinner_end_date > :current_date", {current_date: Time.now})
      @upcoming_dinners += Dinner.attended_by(current_hiker)
        .where("dinner_end_date > :current_date", {current_date: Time.now})
      @upcoming_dinners = @upcoming_dinners.sort{|a,b| a.dinner_start_date <=> b.dinner_start_date }
      respond_to do |format|
        format.html { render template: "home/dashboard" }
      @hungry_hikers = Hiker.all.where("id != :current_hiker", {current_hiker: current_hiker})
        .where("avatar_file_name IS NOT NULL")
        .order("RANDOM()").limit(10);

      end
    end
  end
end
