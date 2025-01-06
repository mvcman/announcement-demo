class InvitationsController < ApplicationController 

    def accepts 
    end 

    def update 
        user = User.find_by_token_for(:password_reset, params[:invitation_token])

        if user.nil? 
            flash[:notice] = "Invalid token"
            redirect_to new_password_reset_path 
        elsif user.update(password_reset_params)
            sign_in user 
            redirect_to dashboard_path, notice: "password reset succesffully!"
        else 
            flash.now[:notice] = user.errors.full_messages.first
            render :edit, status: :unprocessable_entity
        end 
    end

    private 
    def password_reset_params 
        params.require(:password_reset).permit(:password, :password_confirmation)
    end
end 