class Organizations::AnnouncementsController < Organizations::BaseController
    before_action :set_data, only: %i[new edit create update]
    before_action :set_announcement, only: %i[edit update show destroy] 

    def index 
        @announcements = @organization.announcements
        @announcements = Announcement.includes(:announcement_recipients).where(organization_id: @organization.id).where(
            announcement_recipients: {
              announceable_type: %w[User Department Organization],
              announceable_id: [
                current_user.id,                              # Directly for the employee
                current_user&.departments&.find_by(organization: @organization),                  # For the employee's department
                @organization.id                 # For the employee's organization
              ]
            }
          ).distinct
    end 

    def new 
        @announcement = Announcement.new
    end 

    def create 
        ActiveRecord::Base.transaction do 
            begin 
                @announcement = @organization.announcements.new(announcement_params.merge(user_id: current_user.id, organization_id: @organization.id))
                raise "At least one recipient must be selected!" if !params[:announceable_ids].present?
                if @announcement.save 
                    create_recipients
                    redirect_to organization_announcements_path(@organization), notice: "announcement created successfully!"
                else
                    flash[:notice] = @announcement.errors.first.message
                    render :new, status: :unprocessable_entity
                end
            rescue => e 
                p "My error is #{e.message}"
                ActiveRecord::Rollback
                flash[:notice] = e.message
                render :new, status: :unprocessable_entity
            end
        end
    end 

    def show 
    end 

    def edit 
    end 

    def update 
        @announcement.transaction do
            begin
                if @announcement.update(announcement_params)
                    @announcement.announcement_recipients.destroy_all 
                    create_recipients
                    redirect_to organization_announcements_path(@organization), notice: "announcement updated successfully!"
                else
                    render :edit, status: :unprocessable_entity
                end
            rescue => e 
                p "Error is #{e.message}"
                ActiveRecord::Rollback
                flash.now[:notice] = "Failed to update"
                render :edit, status: :unprocessable_entity
            end
        end
    end 

    def destroy 
        if @announcement.destroy 
            redirect_to organization_announcements_path(@organization), notice: "announcement created successfully!"
        end
    end 

    private 

    def announcement_params 
        params.require(:announcement).permit(:title, :content, :severity, :recipient_type)
    end 

    def set_announcement 
        @announcement = Announcement.find(params[:id])
    end

    def set_data 
        @departments = @organization.departments 
        @users = @organization.users
    end

    def create_recipients 
        recipient_ids = params[:announceable_ids] || []
        recipient_type = params[:announcement][:recipient_type]

        if recipient_ids.blank?
            raise "At least one recipient must be selected!"
        end

        recipient_ids.each do |id|
            @announcement.announcement_recipients.create!(
                announceable_id: id, 
                announceable_type: recipient_type
            )
        end
    end
end 