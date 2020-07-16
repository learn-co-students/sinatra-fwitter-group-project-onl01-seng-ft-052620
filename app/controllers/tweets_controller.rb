class TweetsController < ApplicationController
    get '/tweets' do 
        if !Helpers.logged_in?(session)
            redirect '/login'
        end
        @user = Helpers.current_user(session)
        erb :'tweets/index'
    end

    get '/tweets/new' do
        if Helpers.logged_in?(session)
            erb :'tweets/new'
        else
            redirect '/login'    
        end
    end

    post '/tweets' do
        #creates and saves to the database
        user = Helpers.current_user(session)
        if params[:content].empty?    
            redirect "/tweets/new"
        end
        tweet = Tweet.create(content: params[:content])
        user.tweets << tweet
        redirect "/tweets/#{tweet.id}"
    end

    get '/tweets/:id' do
        if Helpers.logged_in?(session)
            @tweet = Tweet.find(params[:id])
            @user = User.find(@tweet.user_id)
            erb :'tweets/show'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do 
        if Helpers.logged_in?(session)
            @tweet = Tweet.find(params[:id])
            if  @tweet.user_id == session[:user_id]   
                erb :'tweets/edit'
            end
        else
            redirect'/login'
        end
    end

    patch '/tweets/:id' do
        tweet = Tweet.find(params[:id])
        if !params[:content].empty?    
            tweet.content = params[:content]
            tweet.save
            redirect "/tweets/#{tweet.id}"
        else
            redirect "/tweets/#{tweet.id}/edit"
        end
    end

    delete '/tweets/:id/delete' do
        tweet = Tweet.find(params[:id])
        if tweet.user_id == session[:user_id]    
            tweet.delete
            redirect '/tweets'
        else
            redirect '/login'
        end
    end

end
