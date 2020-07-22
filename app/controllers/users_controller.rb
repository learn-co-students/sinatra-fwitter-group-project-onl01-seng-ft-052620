class UsersController < ApplicationController

        get '/signup' do 
            redirect_to_if_logged_in
            erb :'users/signup'
        end 

        post '/signup' do 
            user = User.new(params)
            if user.save 
                login_user(user)
                redirect '/tweets'
            else 
                redirect '/signup'
            end 
        end 

        get "/users/:slug" do 
            @user = User.find_by_slug(params[:slug])
            erb :'users/show'
        end 

end
