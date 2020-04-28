class SessionsController < ApplicationController
    # skip_before_filter :set_current_user
    def index
        logger.debug(session.to_hash)
        @current_user = Moviegoer.where(:uid =>session[:user_id])
        logger.debug(@current_user.length)
    end
    def create
        auth=request.env["omniauth.auth"]
        logger.debug(auth)
        user = Moviegoer.new(:provider => auth["provider"], :uid => auth["uid"],:name => auth["info"]["name"])
        user.save
        @name = user.name
        session[:user_id] = user.uid
        redirect_to root_path
        
    end
    def destroy
        session.delete(:user_id)
        user = Moviegoer.where(:uid =>session[:user_id])
        user.destroy_all
        flash[:notice] = 'Logged out successfully.'
        redirect_to root_path
    end
end
