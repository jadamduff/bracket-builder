class BracketsController < ApplicationController

  get '/brackets/new' do
    if logged_in?
      @js = ["new_bracket.js"]
      erb :'/brackets/new'
    else
      redirect '/login'
    end
  end

end
