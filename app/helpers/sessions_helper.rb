module SessionsHelper
  def current_user
    @current_user ||= Session.find_user(cookies[:session_token])
  end

  def current_user=(user)
    @current_user = user
    new_session = user.sessions.create
    if params[:remember_me]
      cookies.permanent['session_token'] = new_session.session_token
    else
      cookies['session_token'] = new_session.session_token
    end
  end

  def require_logged_in!
    unless current_user
      if request.xhr?
        render text: "not logged in", status: 401
      else
        redirect_to new_session_url
      end
    end
  end

  def destroy_session
    Session.find_by_session_token(cookies[:session_token]).destroy
    cookies[:session_token] = nil
    @current_user = nil
  end
end
