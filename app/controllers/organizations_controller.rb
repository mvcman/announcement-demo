class OrganizationsController < MainController 
    before_action :set_organization, only: [:edit, :update, :destroy, :show]

    def new 
        @organization = Organization.new 
    end 
    
    def create 
        @organization = Organization.new(org_params)
        @organization.organization_employees.build(user: current_user, role: OrganizationEmployee.roles[:admin])
        if @organization.save
            redirect_to organization_path(@organization), notice: "Organization created successfully!" 
        else 
            flash.now[:notice] = "failed to create organization"
            render :new, status: :unprocessable_entity
        end 
    end 

    def show 
        @approval_setting = @organization.approval_settings.first || @organization.approval_settings.create(require_approvals: 2)
    end 

    def edit 
    end 

    def update 
        if @organization.update(org_params)
            redirect_to organization_path(@organization), notice: "updated successfully!"
        else 
            flash.now[:notice] = "failed to create!"
            render :edit, status: :unprocessable_entity
        end 
    end 

    def destroy 
        if @organization.destroy 
            redirect_to dashboard_path 
        else 
            redirect_to organization_path(@organization) 
        end
    end

    def update_approval_setting 
        organization = Organization.find(params[:organization_id])
        @approval_setting = ApprovalSetting.find_by(organization_id: params[:organization_id])
        if @approval_setting.update(require_approvals: params[:require_approvals])
            redirect_to organization_path(organization), notice: "setting updated successfully!"
        else 
            redirect_to organization_path(organization), alert: "Failed to update settings!"
        end
    end

    private

    def set_organization 
        @organization = Organization.find(params[:id])
        @current_membership = current_user.organization_employees.find_by(organization: @organization)
    end 

    def org_params 
        params.require(:organization).permit(:name, :logo)
    end 
end