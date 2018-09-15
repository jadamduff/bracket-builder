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

  post '/brackets' do
    @bracket = Bracket.create(title: params[:title], owner_id: current_user.id)
    params[:bracket][:teams].each do |team|
      Team.create(name: team, user_id: User.find_by(username: team).id, bracket_id: @bracket.id)
    end
    redirect "/brackets/#{@bracket.id}"
  end

  get '/brackets/:id' do
    @bracket = Bracket.find(params[:id])
    @teams = @bracket.teams
    erb :'/brackets/view'
  end

end
