class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @user = current_user
            @tweets = Tweet.all.sort_by {|x| x.created_at}.reverse

            erb :'tweets/index'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            @user  = current_user

            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if params[:content] != ""
            Tweet.create(params)

            redirect '/tweets'
        else 
            redirect '/tweets/new'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @user = current_user
            @tweet = Tweet.find(params[:id])

            erb :'tweets/show'
        else 
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            erb :'tweets/edit'
        else
            redirect 'login'
        end
    end

    patch '/tweets/:id' do
        if params[:content] != ""
            @tweet = Tweet.find(params[:id])

            if current_user == @tweet.user
                @tweet.update(content:params[:content])
            end

            redirect "/tweets/#{@tweet.id}"
        else
            redirect "/tweets/#{params[:id]}/edit"
        end
    end

    delete '/tweets/:id/delete' do
        if current_user.id == params[:id].to_i
            Tweet.destroy(params[:id])
        end
        redirect '/tweets'
    end

end
