class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect '/profile'
    else
      erb :'sessions/login'
    end
  end

  post '/sessions' do
    login(params[:username], params[:password])
    if logged_in?
      redirect '/profile'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    logout!
    redirect '/login'
  end

end
