class UsersController < ApplicationController
    
    get '/signup' do
        if logged_in?
            @tweets = Tweet.all
            redirect to "/tweets"
        else
            erb :'users/create_user'
        end
    end

    get '/users/:id' do
        @user = User.find(params[:id])
        erb :'users/show'
    end

    post '/signup' do
        user = User.new(params)
        if user.save
            login(user.username, user.password)
        else 
            redirect to '/signup'
        end
    end
    

    get '/login' do
        if logged_in?
            @tweets = Tweet.all
            redirect to "/tweets"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        if params[:username] && params[:password] 
            login(params[:username], params[:password])
        else
            redirect to '/login'
        end
    end

    get '/logout' do
        if logged_in?
            logout
            redirect to '/login'
        else
            redirect to '/'
        end
    end


end
