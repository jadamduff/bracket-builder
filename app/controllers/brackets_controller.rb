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
    set_bracket(@bracket, params[:bracket][:teams])
    redirect "/brackets/#{@bracket.id}"
  end

  get '/brackets/:id' do
    @bracket = Bracket.find(params[:id])
    @rounds = @bracket.rounds
    @teams = @bracket.teams
    erb :'/brackets/view'
  end

  def set_bracket(bracket, teams)
    @team_ids = []
    @num_teams = nil
    @num_games = nil
    num_games_arr = [4, 8, 16, 32, 64, 128]

    teams.each do |team|
      if team != ""
        new_team = Team.create(name: team, user_id: User.find_by(username: team).id, bracket_id: bracket.id)
        @team_ids << new_team.id
      end
    end

    @team_ids = @team_ids.shuffle

    @num_teams = bracket.teams.count
    @num_games = num_games_arr.detect {|x| x > @num_teams} / 2
    @round1 = Round.create(number: 1, bracket_id: bracket.id)
    @num_games.times do
      Game.create(round_id: @round1.id)
    end
    @round1.games.each do |game|
      if game.team1_id == nil
        game.team1_id = @team_ids[0]
        @team_ids.shift
      elsif game.team2_id == nil && !@team_ids.empty?
        game.team2_id = @team_ids[0]
        @team_ids.shift
      end
    end
  end

end
