class MainController < ActionController::Base
    include Authentication
    layout "main"
    before_action :require_authentication

    helper_method :current_user, :signed_in

    private 

    def current_user 
        Current.user 
    end

    def signed_in? 
        Current.user.present?
    end
end
