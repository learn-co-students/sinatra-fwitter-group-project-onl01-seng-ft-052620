class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @user = current_user
            @tweets = Tweet.all
            erb :'tweets/index'
        else
            redirect to '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            @user = current_user
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            erb :'tweets/show'
        else
            redirect to '/login'
        end
    end


    post '/tweets' do
        tweet = current_user.tweets.build(content: params[:content])
        if tweet.save
            redirect to "/tweets/#{tweet.id}"
        else
            redirect to "/tweets/new"
        end
    end

    get '/tweets/:id/edit' do
        if logged_in? 
            @tweet = Tweet.find(params[:id])
            erb :'tweets/edit'
        else
            redirect to '/login'
        end
    end

    patch '/tweets/:id' do
        tweet = Tweet.find(params[:id])
        tweet.content = (params[:content])
        if tweet.save
            redirect to "/tweets/#{tweet.id}"
        else
            redirect to "tweets/#{tweet.id}/edit"
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            tweet = Tweet.find(params[:id])
            if tweet.user == current_user
                tweet.destroy
            end
            redirect to '/tweets'
        else 
            redirect to '/login'
        end
    end

end
