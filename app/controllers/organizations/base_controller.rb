class Organizations::BaseController < MainController 
    before_action :set_organization 
    before_action :set_current_user_membership 

    private 

    def set_organization 
        @organization = Organization.find(params[:organization_id])
    end

    def set_current_user_membership 
        @current_membership = current_user.organization_employees.find_by(organization: @organization)
    end 
end 