class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    include MailerHelper
    layout 'dashboard'

    def create
        unless params[:telephone] == ""
            redirect_to error_path(future: new_user_path), notice: 'Fehler: Telefonnummer nicht erlaubt. You must be a bot ;)'
            return
        end
        @user = User.new(name: params[:name], email: params[:email], role: 0, university_id: params[:university_id], paid: false, password: params[:password], password_confirmation: params[:password_confirm])
        if @user.valid?
            @user.save
            addToMailingList(@user)
            log_in @user
            redirect_to landing_path
        else
            future = new_user_path
            error_messages = @user.errors.full_messages.join(', ')
            redirect_to error_path(future: future), notice: "Fehler: #{error_messages}"
        end
    end
end
