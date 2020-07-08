class UsersController < ApplicationController

    get '/login' do
        if logged_in?
            redirect '/tweets'
        else
            erb :'users/login'
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

    get '/signup' do
        if logged_in?
            redirect '/tweets'
        else
            erb :'users/signup'
        end
    end

    post '/signup' do
        user = User.new(params)
        user.email.downcase!

        if user.username != "" && user.password != "" && user.save
            session[:user_id] = user.id
            redirect '/tweets'
        else
            redirect '/signup'
        end
    end

    get '/logout' do
        session.clear

        redirect '/login'
    end

    get '/users/:slug' do
        @user = User.all.find{|x| x.slug == params[:slug]}

        erb :'users/show'
    end
end
