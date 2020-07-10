require './config/environment'
use Rack::MethodOverride

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'thank you michael'
  end

  get '/' do
    erb :home
  end

  get '/signup' do
    redirect_to_if_logged_in
    erb :'/users/new'
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/sessions/new'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/users/show' do
    erb :'/users/show'
  end

  get '/new' do
    redirect_to_if_not_logged_in
    redirect 'tweets/new'
  end

  # get '/:id/edit' do
  #   redirect_to_if_not_logged_in
  #   redirect 'tweets/:id/edit'
  # end

  # get '/show' do
  #   redirect_to_if_not_logged_in
  #   redirect '/tweets/show'
  # end

  helpers do
    def redirect_to_if_logged_in
      redirect '/tweets' if logged_in?
    end

    def redirect_to_if_not_logged_in
      redirect '/login' unless logged_in?
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

  end

end
