class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'sessions/login'
    end
  end

  post '/sessions' do
    login(params[:username], params[:password])
    if logged_in?
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    logout!
    redirect '/login'
  end

end
