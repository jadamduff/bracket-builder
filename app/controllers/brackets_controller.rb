class BracketsController < ApplicationController

  get '/brackets/new' do
    if logged_in?
      erb :'/brackets/new'
    else
      redirect '/login'
    end
  end

end
