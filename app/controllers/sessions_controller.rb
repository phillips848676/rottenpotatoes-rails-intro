class SessionsController < ApplicationController
    # skip_before_filter :set_current_user
    @id = 0
    def index

        # @current_user = Moviegoer.where(:uid => @id)

    end
    def create
        auth=request.env["omniauth.auth"]
        logger.debug(auth)
        user = Moviegoer.new(:provider => auth["provider"], :uid => auth["uid"],:name => auth["info"]["name"])
        user.save
        @id = user.uid
        session[:user_id] = user.uid
        redirect_to root_path
    end
    def destroy
        session.delete(:user_id)
        user = Moviegoer.where(:uid =>session[:user_id])
        @id = 0
        user.destroy_all
        flash[:notice] = 'Logged out successfully.'
        redirect_to root_path
    end
end
