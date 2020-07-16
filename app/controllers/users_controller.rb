class UsersController < ApplicationController
    
    get '/signup' do
        if Helpers.logged_in?(session)
            redirect '/tweets'
        end
        erb :'users/signup'
    end

    post '/signup' do
        user = User.new(username: params[:username], email: params[:email], password: params[:password])
            if user.save && !user.username.empty? && !user.email.empty?
                session[:user_id] = user.id
                redirect '/tweets'
            else
                redirect '/signup'
            end
    end

    get '/login' do
        if Helpers.logged_in?(session)
            redirect '/tweets'
        end
        erb :'users/login'
    end

    post '/login' do
        #add user_id to the sessions hash
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

    get "/users/:username" do
        
        @user = User.find_by_slug(params[:username])
        
        erb :'users/show'
    end
end
