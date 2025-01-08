class Organizations::ApprovalRequestsController < Organizations::BaseController 
    before_action :set_request, only: %i[ show edit update destroy ]
    def index 
        @approval_requests = @current_membership.admin? || @current_membership.approver? ? @organization.approval_requests.includes(:approvals) : @organization.approval_requests.includes(:approvals).where(requester: current_user)
    end

    def new 
        @approval_request = ApprovalRequest.new
    end 

    def create 
        @approval_request = @organization.approval_requests.new(request_params.merge(requester: current_user))
        if @approval_request.save 
            redirect_to organization_approval_requests_path(@organization), notice: "Rquest sent successfully!"
        else
            flash.now[:alert] = @approval_request.errors.first.message
            render :new, status: :unprocessable_entity
        end
    end 

    def edit 
    end 

    def show
    end 

    def update 
        if @approval_request.update(request_params)
            redirect_to organization_approval_requests_path(@organization), notice: "request updated successfully!"
        else 
            flash.now[:notice] = "Failed to update the request"
            render :edit, status: :unprocessable_entity
        end
    end 
    
    def destroy 
        if @approval_request.destroy 
            redirect_to organization_approval_requests_path(@organization), notice: "request destroyed successfully!"
        end
    end 

    def update_approval_request
        # Add uniuq index so one user can't have mltiple approvals 
        return unless params[:approver_id].present? && params[:id].present?
        status = params[:commit].downcase == "approve" ? "approved" : "denied"
        approver = User.find_by(id: params[:approver_id])
        ap_request = ApprovalRequest.find_by(id: params[:id])
        @approval = ap_request.approvals.find_by(approver: approver)
        if @approval.present? 
            @approval.update(comment: params[:comment], status: status)
            redirect_to organization_approval_requests_path(@organization), notice: "request updated  successfully!"
        else
            ap_request.approvals.create(user_id: approver.id, approval_request: ap_request, comment: params[:comment], status: status)
            redirect_to organization_approval_requests_path(@organization), notice: "request added successfully!"
        end
    end

    private 

    def request_params 
        params.require(:approval_request).permit(:title, :description, images: [])
    end 

    def set_request
        @approval_request = ApprovalRequest.find(params[:id])
    end 
end