class OverviewController < ApplicationController
    before_action :require_login
    def index
        @events = Event.where(current: true)
    end

    private

    def require_login
        unless current_user && current_user.role == 0
            redirect_to root_path, notice: 'Diese Seite ist nur für angemoldene Mitglieder zugänglich.'
        end
    end
end
