class SessionsController < ApplicationController 
    before_action :require_authentication, only: :destroy
    before_action :redirect_if_signed_in, only: %i[new create]
    
    def new 
    end 

    def create 
        if user = User.authenticate_by(session_params)
            sign_in user
            redirect_to dashboard_path, notice: "Logged in successfully with #{user.email}!"
        else 
            flash.now[:notice] = "Invalid email or password!"
            render :new, status: :unprocessable_entity
        end 
    end 

    def destroy 
        sign_out 
        redirect_to new_session_path, notice: "You have beedn signed out!"
    end

    private 

    def session_params 
        params.require(:session).permit(:email, :password)
    end 
end