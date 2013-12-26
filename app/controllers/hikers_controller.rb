# app/controllers/hikers_controller.rb
class HikersController < ApplicationController

  def edit
    if request.get?
      @hiker = current_hiker
      respond_to do |format|
        format.html { render template: "hikers/edit" }
      end
    else
      if request.patch? || request.post?
        @hiker = Hiker.find(params[:hiker][:id])

        if !params[:hiker][:avatar].blank?
          picture_unescaped=URI.unescape(params[:hiker][:avatar])
          escaped = picture_unescaped.slice((picture_unescaped.index(','))..picture_unescaped.length)
          decoded_data = Base64.decode64(escaped)
          data = StringIO.new(decoded_data)
          data.class_eval do
            attr_accessor :content_type, :original_filename
          end

          data.content_type = params[:hiker][:content_type]
          data.original_filename = File.basename(params[:hiker][:original_filename])
          @hiker.avatar=data
          success = @hiker.save
          if success
            respond_to do |format|
              format.json  { render :json => {message: "Image saved.", status: 201}.to_json }
            end
          else
            respond_to do |format|
              format.json  { render :json => {message: "Image could not be saved.", status: 500, errors: @hiker.errors.to_hash(true)}.to_json }
            end
          end          
        else
          @hiker.first_name = params[:hiker][:first_name]
          @hiker.last_name = params[:hiker][:last_name]
          @hiker.birth = Date.strptime(params[:hiker][:birth]+" CET", '%m/%d/%Y %Z')
          @hiker.about = params[:hiker][:about]
          @hiker.save
          redirect_to root_url
        end
      end
    end
  end

end 
