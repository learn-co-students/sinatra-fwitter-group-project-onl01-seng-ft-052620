class SessionsController < ApplicationController
    get '/login' do 
        redirect_to_if_logged_in
        erb :'sessions/new'
    end 

    post '/login' do 
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            login_user(@user)
            redirect '/tweets'
        else
            redirect '/login'
        end 
    end 

    get '/logout' do 
        session.clear 
        redirect '/login'
    end 
end 