class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'/tweets/index'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if params[:content] == ""
            redirect '/tweets/new'
        else
            @tweet = current_user.tweets.create(content: params[:content])
            redirect "/tweets"
        end 
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :"tweets/show"
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user == current_user
                erb :'tweets/edit'
            else
                redirect '/tweets'
            end
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        if logged_in?
            if params[:content] == ""
                redirect "/tweets/#{params[:id]}/edit"
            else
                @tweet = Tweet.find_by_id(params[:id])
                if @tweet.user == current_user
                    @tweet.update(content: params[:content])
                    redirect "/tweets/#{@tweet.id}"
                else
                    redirect "/tweets"
                end
            end
        else
            redirect '/login'
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user == current_user
                @tweet.delete
                redirect '/tweets'
            else
                redirect '/login'
            end
        end
    end
end
