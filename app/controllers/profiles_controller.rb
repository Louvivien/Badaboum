class ProfilesController < ApplicationController

	before_action :authenticate_user!
	
	def show
		@profile = current_user.profile
		@children = Child.where(profile_id: @profile.id)
    @products = current_user.uploaded_products
  end

	def edit
		@profile = current_user.profile
	end 

	def update
		@profile = current_user.profile
	
		respond_to do |format|
      if @profile.update profile_params
      	if params[:profil_picture].present?
        	@profile.profil_picture.attach(params[:profil_picture])
      	end
        format.html { redirect_to profile_path, notice: "Profil mis à jour!" }
        format.json { render :edit, status: :ok, location: @profile }

      else
        format.html { redirect_to edit_profile_path, flash: { error: "Le profil n'a pas pu être mis à jour!" } }
        format.json { render json: @profile.errors.messages, status: :unprocessable_entity }
      end
    end
  end



	private

    def profile_params
      params.permit(:first_name, :last_name, :phone_number, :street, :city, :zip_code, :description)
    end
end
