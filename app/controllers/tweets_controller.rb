class TweetsController < ApplicationController

  get '/tweets' do
    redirect_to_if_not_logged_in
    @tweets = Tweet.all
    erb :'tweets/index'
  end

  get 'tweets/new' do
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
    @tweet = Tweet.find_by_id(params[:id])
    erb :'/tweets/show'
  end

  get '/tweets/:id/edit' do
    redirect_to_if_not_logged_in
    @tweet = Tweet.find_by_id(params[:id])
    erb :'tweets/edit'
  end

  patch 'tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.update(content: params[:content])
      redirect '/tweets'
    else
      redirect "tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && current_user.owns_tweet?(@tweet)
      @tweet.destroy
    end
      redirect '/tweets'
  end

  # private
  #   def set_todo
  #     @tweet = Tweet.find_by_id(params[:id])
  #   end
  # end

end
