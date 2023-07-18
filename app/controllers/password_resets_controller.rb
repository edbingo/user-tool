class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  include MailerHelper
  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      sendResetLink(@user)
    end
    redirect_to root_path, notice: "Wenn die E-Mail-Adresse existiert, wurde ein Link zum Zurücksetzen des Passworts an diese gesendet."
  end

  def edit
    @user = User.find_by_email(params[:email].downcase)
  end

  def update
    if params[:user][:password].empty?
      redirect_to edit_password_reset_path(params[:id]), notice: "Passwort darf nicht leer sein."
    elsif @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      log_in @user
      redirect_to root_path, notice: "Passwort wurde zurückgesetzt."
    else
      redirect_to root_path, notice: "Passwort konnte nicht zurückgesetzt werden."
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by_email(params[:email].downcase)
  end

  def valid_user
    unless @user
      redirect_to root_path
    end
  end

  def check_expiration
    @user = User.find_by_email(params[:email].downcase)
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, notice: "Link zum Zurücksetzen des Passworts ist abgelaufen."
    end
  end
end
