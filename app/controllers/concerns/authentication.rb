module Authentication 

    def require_authentication 
        restore_authentication || request_authentication
    end 

    def request_authentication 
        redirect_to new_session_path
    end

    def restore_authentication 
        if session = session_from_cookies
            Current.user = session.user 
        end
    end 

    def sign_in(user)
        p "request #{request.host} #{request.remote_ip}"
        session = user.sessions.create(host: request.host, remote_ip: request.remote_ip)
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true }
    end

    def session_from_cookies 
        Session.find_by(id: cookies.signed[:session_id])
    end

    def sign_out 
        session = session_from_cookies
        session.user.update_columns(active: false)
        session.destroy! 
        cookies.delete(:session_id)
    end 

    def redirect_if_signed_in
        if restore_authentication
          redirect_to dashboard_path, notice: "You are already signed in"
        end
    end
end