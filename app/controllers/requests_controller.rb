class RequestsController < ApplicationController

  def new
    @request = Request.new
    target_dinner = Dinner.find(params[:dinnerid])
    if target_dinner.blank?
      redirect_to root_url
    else
      @request.dinner=target_dinner
    end
  end

    #Create should be a post request

  def create
    logger.debug 'def create request'
    if request.post? 
      @request = Request.new()
      @request.hiker = current_hiker
      @request.dinner = Dinner.find(params[:request][:dinner_id])
      @request.subject = params[:request][:subject]
      @request.body = params[:request][:body]
      success = @request.save
      if !success
        respond_to do |format|
          format.html { render template: "requests/new" }
        end
      else
        redirect_to root_url
      end
    end
  end

  def update_state
    @request = Request.find(params[:request][:id])
    old_state = @request.state
    new_state = params[:request][:state]
    debugger
    # Check for allowed State transitions
    if old_state == 'active' and (new_state == 'declined' or new_state == 'accepted')
      @request.state = new_state
      success = @request.save
      if success
        respond_to do |format|
          format.json  { render :json => {message: "Request #{new_state}.", status: 201}.to_json }
        end
      else
        respond_to do |format|
          logger.error @request.errors.to_hash(true).to_s
          format.json  { render :json => {message: "Request could not be updated.", status: 500, errors: @request.errors.to_hash(true)}.to_json }
        end
      end
    end
  end






end
