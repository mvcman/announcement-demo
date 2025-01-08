class Organizations::OrganizationEmployeesController < Organizations::BaseController 
    before_action :set_organization_employee, only: %i[edit update destroy]

    def index 
        @memberships = @organization.organization_employees.includes(:user)
    end 

    def new
    end 

    def create 
        user = User.find_by(email: params[:organization_employee][:email]) || find_or_invite_user(params[:organization_employee][:email]) 

         
        add_user_to_organization(user, params[:organization_employee][:role]) if user.present?
        redirect_to organization_organization_employees_path(@organization), notice: "invitation sent successfully!"
    end 

    def edit 
    end 

    def update 
        if @organization_employee.update(org_emp_params)
            redirect_to organization_organization_employees_path(@organization), notice: "Role updated successfully!"
        else 
            flash.now[:alert] = "Failed to update user role!"
            render :edit, status: :unprocessable_entity
        end
    end 

    def destroy 
    end 

    private 

    def org_emp_params 
        params.require(:organization_employee).permit(:role)
    end

    def set_organization_employee
        @organization_employee = @organization.organization_employees.find(params[:id])
    end 

    def find_or_invite_user(email)
        user = User.create(email: email, password: "password")
        token = user.generate_token_for(:password_reset) if user.present?

        InvitationMailer.with(user: user, invitation_token: token).send_invitation.deliver_later if token.present?
        return user
    end 

    def add_user_to_organization(user, role)
        membership = user.organization_employees.find_by(organization: @organization)
        if membership.present?
          errors.add(:base, "#{email} is already a member of this organization.")
          false
        else
          user.organization_employees.create(organization: @organization, role: role)
          true
        end
    end
end 