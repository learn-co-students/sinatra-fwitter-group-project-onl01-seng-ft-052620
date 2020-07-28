class TweetsController < ApplicationController

    get '/tweets' do
        redirect_to_if_not_logged_in
        @tweets = Tweet.all
        erb :'tweets/index'
    end

    get '/tweets/new' do
        redirect_to_if_not_logged_in
        erb :'tweets/new'
    end

    post '/tweets' do
        tweet = current_user.tweets.build(params)
        if tweet.save
            redirect '/tweets'
        else
            redirect '/tweets/new'
        end
    end

    get '/tweets/:id' do
        redirect_to_if_not_logged_in
        set_tweet
        erb :'tweets/show'
    end

    get '/tweets/:id/edit' do
        redirect_to_if_not_logged_in
        set_tweet
        if current_user.owns_tweet?(@tweet)
            erb :'tweets/edit'
        else
            redirect '/tweets'
        end
    end

    patch '/tweets/:id' do
        set_tweet
        if @tweet.update(content: params[:content])
            redirect '/tweets'
        else
            redirect "/tweets/#{@tweet.id}/edit"
        end
    end

    delete '/tweets/:id' do
        set_tweet
        if logged_in? && current_user.owns_tweet?(@tweet)
            @tweet.destroy
        end
        redirect '/tweets'
    end

    private
    def set_tweet
        @tweet = Tweet.find_by_id(params[:id])
    end
end
