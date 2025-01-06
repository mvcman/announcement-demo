class InvitationMailer < ApplicationMailer 
    def send_invitation
        @user = params[:user]
        @invitation_token = params[:invitation_token]

        mail to: @user.email, subject: "Accept invitation!"
    end
end