class DinnersController < ApplicationController
  before_filter :authenticate_hiker!
  before_action :correct_user,   only: [:update]

  def new
  	@dinner = Dinner.new(title: current_hiker.username+"'s Dinner", 
                        active: false,
                        dinner_start_date: DateTime.now + 4.hours,
                        dinner_end_date: DateTime.now + 6.hours)
  	@dinner.hiker=current_hiker
    result=@dinner.save
      logger.debug @dinner.errors.to_hash
  end

  def create
    if request.post? || request.put?  || request.patch?
      dinner = Dinner.find(params[:dinner][:id])
      if !params[:dinner][:picture].blank?
        picture_unescaped=URI.unescape(params[:dinner][:picture])
        escaped = picture_unescaped.slice((picture_unescaped.index(','))..picture_unescaped.length)
        logger.debug escaped
        decoded_data = Base64.decode64(escaped)
        data = StringIO.new(decoded_data)
        data.class_eval do
          attr_accessor :content_type, :original_filename
        end

        data.content_type = params[:dinner][:content_type]
        data.original_filename = File.basename(params[:dinner][:original_filename])
        dinner.picture=data
        success = dinner.save
        if success
          respond_to do |format|
            format.json  { render :json => {message: "Image saved.", status: 201}.to_json }
          end
        else
          respond_to do |format|
            format.json  { render :json => {message: "Image could not be saved.", status: 500, errors: dinner.errors.to_hash(true)}.to_json }
          end
        end
      else
        dinner.title = params[:dinner][:title]
        dinner.hiker = current_hiker
        dinner.description = params[:dinner][:description]
        dinner.active = true
        begin
          dinner.dinner_start_date=DateTime.strptime(params[:dinner][:dinner_start_date]+" CET", '%m/%d/%Y %H:%M %Z')
          dinner.dinner_end_date=DateTime.strptime(params[:dinner][:dinner_end_date]+" CET", '%m/%d/%Y %H:%M %Z')
        rescue ArgumentError
          logger.debug "Invalid Date Format when creating a Dinner!"
        end
        result = dinner.save
      	
      	if !result
      	  session[:errors] = dinner.errors.to_hash(true)
        else
          redirect_to action: "details", dinnerid: dinner.id
        end
      end
    end
  end

  def show
    @dinners = Dinner.all.where(hiker: current_hiker, active: true).order("dinner_start_date")
  end

  def details
    @dinner = Dinner.find(params[:dinnerid])
    @participants = Hiker.creator_of(@dinner)
    @participants += Hiker.attending(@dinner)
  end

  def update
    sleep(1.5);
    dinner = Dinner.find(params[:dinner][:id])
    if request.post? || request.put?  || request.patch?
      dinner.title = params[:dinner][:title]
      dinner.description = params[:dinner][:description]
      result = dinner.save
      if !result
        respond_to do |format|
          format.json  { render :json => {message: "Changes could not be made!", status: 500, errors: dinner.errors.to_hash(true)}.to_json }
        end 
      else
        respond_to do |format|
          format.json  { render :json => {message: "Dinner successfully updated!", status: 201}.to_json }
        end       
      end
    end
  end

  private

  def correct_user
    dinner = Dinner.find(params[:dinner][:id])
    if current_hiker != dinner.hiker
        dinner.hiker.errors = "Only the owner of a dinner can make changes!"
      if request.post? 
        respond_to do |format|
          format.json  { render :json => {message: "Changes could not be made!", status: 500, errors: dinner.errors.to_hash(true)}.to_json }
        end
      end
      redirect_to action: "details"
    end
  end

end
