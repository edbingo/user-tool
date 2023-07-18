class DashboardController < ApplicationController
  include DashboardHelper
  include MailerHelper
  include UsersHelper
  layout 'dashboard'
  before_action :redirect_user
  before_action :require_admin, only: [:admins, :destroyUser, :unis]
  before_action :require_vorstand
  def index
  end

  def admins
    @users = User.all
  end

  def newAdmin
  end

  def editAdmin
    @user = User.find(params[:id])
  end

  def updateAdmin
    @user = User.find(params[:id])
    byebug
    if @user.update(user_params.except(:password, :password_confirmation))
      redirect_to admins_path, notice: 'Admin wurde aktualisiert.'
    else
      error_messages = @user.errors.full_messages.join(', ')
      redirect_to admins_path, notice: 'Admin konnte nicht aktualisiert werden: ' + error_messages
    end
  end

  def viewUser
    @user = User.find(params[:id])
    unless @user.listmonk_id == nil
      @mailingLists = getMailingLists(@user)
    else
      @mailingLists = "Keine"
    end
  end

  def createAdmin
    @user = User.new
    password = generate_password
    User.create(user_params, password: password, password_confirmation: password, paid: true)
    if @user.valid?
      @user.save
      addToMailingList(@user)
      redirect_to admins_path, notice: 'Admin wurde erstellt.'
    else
      error_messages = @user.errors.full_messages.join(', ')
      redirect_to admins_path, notice: 'Admin konnte nicht erstellt werden: ' + error_messages
    end
  end

  def destroyUser
    user = User.find(params[:id])
    if user.role == 3 && User.where(role: 3).count == 1
      redirect_to admins_path, notice: 'Es muss mindestens ein Admin existieren.'
      return
    end
    role = user.role
    user.destroy
    if role > 0
      redirect_to admins_path, notice: 'Benutzer wurde gelöscht.'
    else
      redirect_to students_path, notice: 'Benutzer wurde gelöscht.'
    end
  end

  def events
    @events = Event.all
  end

  def students
      @users = User.all.where(role: 0)
      @users = @users.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def unis
    @universities = University.all
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :role, :university_id)
  end
  
  def redirect_user
    if current_user && current_user.role == 0
      redirect_to overview_path
    end
  end

  def require_admin
    unless current_user && current_user.role == 3
      redirect_to dashboard_path, notice: 'Du hast nicht die nötigen Rechte um diese Seite zu sehen.'
    end
  end

  def require_vorstand
    unless current_user && current_user.role > 0
      redirect_to root_path, notice: 'Du hast nicht die nötigen Rechte um diese Seite zu sehen.'
    end
  end

end
