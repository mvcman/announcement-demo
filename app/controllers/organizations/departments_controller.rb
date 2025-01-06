class Organizations::DepartmentsController < Organizations::BaseController 
    before_action :set_department, only: %i[show edit update destroy]

    def index 
        @departments = @organization.departments
    end 

    def new 
        @department = Department.new
    end 

    def create 
        @department = @organization.departments.new(department_params)

        if @department.save
            redirect_to organization_departments_path(@organization), notice: "Department created successfully!" 
        else 
            render :new, status: :unprocessable_entity
        end
    end 

    def show 
        @organization_employees = User.includes(:organization_employees).where(organization_employees: { organization: @organization }).where.not(organization_employees: { user_id: DepartmentEmployee.joins(:department).where(department: { organization: @organization }).pluck(:user_id) })        
    end 

    def edit 
    end 

    def update 
        if @department.update(department_params)
            redirect_to organization_departments_path(@organization), notice: "Department updated successfully!" 
        else 
            render :edit, status: :unprocessable_entity
        end
    end 

    def destroy 
        if @department.destroy 
            redirect_to organization_departments_path(@organization), notice: "Department destroyed successfully!" 
        end
    end 

    def update_department_user
        @department = Department.find_by(id: params[:id])
        respond_to do |format|
            begin
                if params[:commit].downcase == "add"
                    employee = User.find(params[:user_id])
                    @department.users << employee if employee.present?
                    format.html { redirect_to organization_department_path(@organization, @department), notice: "Added employee to the department" }
                else
                    employee = User.find(params[:user_id])
                    @department.users.destroy(employee)
                    format.html { redirect_to organization_department_path(@organization, @department), notice: "Removed employee from the office " }
                end
            rescue => e 
                p "ERRRor #{e.message}"
                format.html { redirect_to organization_department_path(@organization, @department), notice: e.message }
            end
        end
    end

    private 

    def set_department 
        @department = Department.find(params[:id])
    end

    def department_params
        params.require(:department).permit(:name)
    end
end 