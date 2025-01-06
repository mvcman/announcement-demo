class UsersController < MainController
    before_action :set_user_profile, only: [:show, :edit, :update] 

    def show 
    end 

    def edit 
    end 

    def update
        if @profile.update(user_params)
            redirect_to user_path(@user), notice: "User updated succesffully!"
        else 
            flash.now[:notice] = "Failed to update profile"
            render :edit, status: :unprocessable_entity
        end
    end 

    def update_status 
        p "GOT LLLLLLLLLLLcalled! #{params[:status] == "active" }"
        current_user.update_columns(active: params[:status] == "active" ? true: false)

        ActionCable.server.broadcast "user_activity_channel", {
            user_id: current_user.id,
            status: params[:status] == "active"
        }
        head :ok
    end

    private 

    def set_user_profile
        @user = User.find(params[:id])
        @profile = @user&.profile || @user.create_profile
    end

    def user_params 
        params.require(:profile).permit(:first_name, :last_name, :middle_name, :address, :city, :state, :country, :pin_code, :image)
    end
end