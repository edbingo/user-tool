require 'net/http'
require 'json'

class SessionsController < ApplicationController
  def new
    if (logged_in?)
      redirect_to dashboard_path
    end
  end

  def create
    user = User.find_by(email: params[:email].downcase) # Find user by email
    if user && user.authenticate(params[:password]) # If user exists and password is correct
      log_in user # Log the user in and redirect to the user's show page.
      if params[:remember_me] == '1'
        remember user
      else
        forget user
      end
      redirect_to dashboard_path
    else
      future = root_path
      redirect_to error_path(future: future), notice: 'Fehler: E-Mail oder Passwort falsch.'
    end
  end

  def newUser
    @universities = University.all
  end

  def error
    @future = params[:future]
  end

  def destroy
    log_out
    redirect_to root_path
  end

end
