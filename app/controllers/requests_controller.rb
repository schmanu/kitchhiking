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






end
