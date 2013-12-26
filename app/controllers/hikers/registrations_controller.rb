# app/controllers/hikers/registrations_controller.rb
class Hikers::RegistrationsController < Devise::RegistrationsController



  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      if resource.errors.any?
        session[:errors] = resource.errors.to_hash(true)
      end
      redirect_to root_url
    end
  end

  def edit
    if request.get?
      @hiker = current_hiker
      respond_to do |format|
        format.html { render template: "hikers/edit" }
      end
    else
      if request.put? || request.post
        @hiker = Hikers.find(params[:hiker][:id])
        @hiker.first_name = params[:hiker][:first_name]
        @hiker.last_name = params[:hiker][:last_name]
        @hiker.birth = params[:hiker][:birth]

        redirect_to root_url
      end
    end
  end

end 
