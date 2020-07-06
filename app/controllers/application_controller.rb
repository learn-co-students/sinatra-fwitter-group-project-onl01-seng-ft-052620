require './config/environment'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "super_secret_password"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect to "/tweets"
    else
    erb :signup
    end
  end

  post "/signup" do
    user = User.new(params)
    if !user.username.empty? && !user.email.empty? && user.save
      session[:user_id] = user.id
			redirect to "/tweets"
		else
			redirect to "/signup"
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/tweets"
    else
    erb :login
    end
  end

  post "/login" do
		user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to "/tweets"
    else
    redirect to "/failure"
    end
  end

  get '/tweets' do 
    if logged_in?
    @tweets = Tweet.all
    erb :tweets
    else 
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else 
      redirect to '/login'
    end
  end

  post '/tweets' do
    user = current_user
    if !params["content"].empty?
    user.tweets.create(content: params["content"])
    else 
      redirect to '/tweets/new'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect to "/login"
    end
  end

  get "/users/:username" do
    @user = User.find_by(username: params["username"])
    erb :'user/show'
  end

  get "/tweets/:id" do
    if logged_in?
    @tweet = Tweet.find(params["id"])
    erb :'tweets/show'
    else redirect to '/login'
    end
  end

  get "/tweets/:id/edit" do
    if logged_in?
    @tweet = Tweet.find(params[:id])
    user = current_user
    if user.id == @tweet.user_id
    erb :'/tweets/edit'
    else redirect to '/tweets'
    end
    else redirect to '/login'
    end
  end

  patch "/tweets/:id" do
    @tweet = Tweet.find(params[:id])
    if !params[:tweet][:content].empty?
    @tweet.update(params[:tweet])
    redirect to "/tweets/#{ @tweet.id }"
    else redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete "/tweets/:id" do
    tweet = Tweet.find(params["id"])
    user = current_user
    if user.id == tweet.user_id
    tweet.delete
    redirect to '/tweets'
    else redirect to '/tweets'
    end
  end

  get "/failure" do
    redirect to '/'
  end

  post "/logout" do
    session.clear
    redirect "/login"
  end
  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
