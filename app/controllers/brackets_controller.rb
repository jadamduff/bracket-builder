class BracketsController < ApplicationController

  get '/brackets/new' do
    if logged_in?
      @friends = current_user.friends
      @js = ["new_bracket.js.erb"]
      erb :'/brackets/new'
    else
      redirect '/login'
    end
  end

  post '/brackets' do
    if logged_in?
      @bracket = Bracket.create(title: params[:bracket][:title], owner_id: current_user.id)
      set_bracket(@bracket, params[:bracket][:teams])
      redirect "/brackets/#{@bracket.id}"
    else
      redirect '/login'
    end
  end

  get '/brackets/:id' do
    if logged_in?
      @js = ["view_bracket.js.erb"]
      @bracket = Bracket.find(params[:id])
      @rounds = @bracket.rounds
      @first_round = @bracket.rounds.first
      @teams = @bracket.teams
      erb :'/brackets/view'
    else
      redirect '/login'
    end
  end

  patch '/brackets/:id' do
    if logged_in?
      @bracket = Bracket.find(params[:id])
      if current_user.id == @bracket.owner_id
        params["bracket"]["rounds"].each_with_index do |round, round_index|
          round[1]["games"].each_with_index do |game, game_index|
            @update_game = @bracket.rounds[round_index].games[game_index]
            @update_team1_id = nil
            @update_team2_id = nil
            @update_winner_id = nil
            if !@bracket.teams.where("name = ?", game["team1"]).empty?
              @update_team1_id = @bracket.teams.find_by(name: game["team1"]).id
            end
            if !@bracket.teams.where("name = ?", game["team2"]).empty?
              @update_team2_id = @bracket.teams.find_by(name: game["team2"]).id
            end
            if !@bracket.teams.where("name = ?", game["winner"]).empty?
              @update_winner_id = @bracket.teams.find_by(name: game["winner"]).id
            end
            @update_game.team1_id = @update_team1_id
            @update_game.team2_id = @update_team2_id
            @update_game.winner_id = @update_winner_id
            @update_game.save
          end
        end
        @championship = @bracket.rounds.last.games.first
        if @championship.winner_id != nil
          @team1_name = Team.find(@championship.team1_id).name
          @team2_name = Team.find(@championship.team2_id).name
          @bracket.champ_name = Team.find(@championship.winner_id).name
          @bracket.save
          if @bracket.champ_name == @team1_name
            @bracket.runner_up_name = @team2_name
          else
            @bracket.runner_up_name = @team1_name
          end
          @bracket.save
        end
        redirect "/brackets/#{@bracket.id}"
      else
        redirect '/profile'
      end
    else
      redirect '/login'
    end
  end

  get '/brackets/:id/edit' do
    if logged_in?
      @bracket = Bracket.find(params[:id])
      if current_user.id == @bracket.owner_id
        @teams = @bracket.teams
        @friends = current_user.friends
        @js = ["new_bracket.js.erb"]
        erb :'/brackets/edit'
      else
        redirect '/profile'
      end
    else
      redirect '/login'
    end
  end

  patch '/brackets/:id/edit' do
    if logged_in?
      @bracket = Bracket.find(params[:id])
      if current_user.id == @bracket.owner_id
        @bracket.rounds.delete_all
        @bracket.rounds.each do |game|
          round.games.delete_all
        end
        @bracket.teams.delete_all
        @bracket.champ_name = nil
        @bracket.save
        set_bracket(@bracket, params[:bracket][:teams])
        redirect "/brackets/#{@bracket.id}"
      else
        redirect '/profile'
      end
    else
      redirect '/login'
    end
  end

  delete '/brackets/:id/delete' do
    if logged_in?
      @bracket = Bracket.find(params[:id])
      if current_user.id == @bracket.owner_id
        @bracket.rounds.each do |round|
          round.delete
        end
        @bracket.rounds.delete_all
        @bracket.teams.delete_all
        @bracket.delete
        redirect '/profile'
      else
        redirect '/profile'
      end
    else
      redirect '/login'
    end
  end

  def set_bracket(bracket, teams)
    @team_ids = []
    @num_teams = nil
    @num_games = nil
    @num_rounds = nil
    num_teams_arr = [4, 8, 16, 32, 64, 128]
    num_rounds_arr = [2, 3, 4, 5, 6, 7]

    teams.each do |team|
      if team != ""
        if User.find_by(username: team) != nil && (current_user.friends.include?(User.find_by(username: team)) || current_user.username == team)
          @new_team = Team.create(name: team, user_id: User.find_by(username: team).id, bracket_id: bracket.id)
          User.find(@new_team.user_id).brackets << @bracket if !User.find(@new_team.user_id).brackets.include?(@bracket)
          @team_ids << @new_team.id
        else
          @new_team = Team.create(name: team, bracket_id: bracket.id)
          @team_ids << @new_team.id
        end
      end
    end

    @team_ids = @team_ids.shuffle
    @num_teams = bracket.teams.count

    if @num_teams == 2
      @num_games = 1
      @num_rounds = 1
    else
      @num_teams = num_teams_arr.detect {|x| x >= @num_teams}
      @num_games = @num_teams / 2
      @num_rounds = num_rounds_arr[num_teams_arr.index(@num_teams)]
    end

    @round_count = 1
    @games_in_round = @num_games
    until @round_count > @num_rounds do
      @round = Round.create(number: @round_count, bracket_id: bracket.id)
      @games_in_round.times do
        Game.create(round_id: @round.id)
      end
      @round_count += 1
      @games_in_round = @games_in_round / 2
    end

    @round1 = bracket.rounds.find_by(number: 1)

    populate_games(@round1)
    populate_games(@round1)

  end

  def populate_games(round)
    round.games.each do |game|
      if @num_games == 1
        game.update(team1_id: @team_ids[0])
        game.update(team2_id: @team_ids[1])
      else
        if game.team1_id == nil
          game.update(team1_id: @team_ids[0])
          @team_ids.shift
        elsif game.team2_id == nil && !@team_ids.empty?
          game.update(team2_id: @team_ids[0])
          @team_ids.shift
        end
      end
    end
  end

end
