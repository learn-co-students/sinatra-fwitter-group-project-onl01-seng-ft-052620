require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions 
    set :session_secret, "hi whatsup sup"
  end

  get '/' do 
    erb :home 
  end 

  helpers do 
    def logged_in? 
      !!session[:user_id]
    end 

    def current_user 
      User.find_by_id(session[:user_id])
    end 

    def redirect_to_if_logged_in
      redirect '/tweets' if logged_in? 
    end 

    def redirect_to_if_not_logged_in
      redirect '/login' unless logged_in?
    end 

    def login_user(user)
      session[:user_id] = user.id 
    end 

  end

end
