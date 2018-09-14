class BracketsController < ApplicationController

  get '/brackets/new' do
    if logged_in?
      @friends = current_user.friends
      @js = ["new_bracket.js"]
      erb :'/brackets/new'
    else
      redirect '/login'
    end
  end

end
