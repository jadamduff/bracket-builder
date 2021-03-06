class UsersController < ApplicationController

  get '/profile' do
    redirect_if_not_logged_in
    @user = current_user
    @friend_requests = FriendRequest.where("pending_friend_id = ?", @user.id)
    @friends = @user.friends
    @brackets = @user.brackets.order(created_at: :desc)
    @golds = []
    @brackets.where("champ_name = ?", @user.username).each do |bracket|
      if @user.brackets.include?(bracket)
        @golds << bracket
      end
    end
    @silvers = []
    @brackets.where("runner_up_name = ?", @user.username).each do |bracket|
      if @user.brackets.include?(bracket)
        @silvers << bracket
      end
    end
    erb :'/users/profile'
  end

  post '/users' do
    if User.find_by(username: params[:username]) == nil && User.find_by(email: params[:email]) == nil && params[:username] != "" && params[:email] != "" && params[:password] != ""
      @user = User.new
      @user.username = params[:username]
      @user.email = params[:email]
      @user.password = params[:password]

      if @user.save
        login(@user.username, @user.password)
        redirect '/profile'
      else
        flash[:message] = "Unable to create account."
        redirect '/'
      end
    else
      if User.find_by(username: params[:username]) != nil && User.find_by(email: params[:email]) != nil
        flash[:message] = "That username is taken.<br >That email is taken."
      elsif User.find_by(username: params[:username]) != nil
        flash[:message] = "That username is taken."
      elsif User.find_by(email: params[:email]) != nil
        flash[:message] = "That email is taken."
      elsif params[:username] == ""
        flash[:message] = "A username is required."
      elsif params[:email] == ""
        flash[:message] = "An email is required."
      elsif params[:password] == ""
        flash[:message] = "A password is required."
      end
      redirect '/'
    end
  end

  get '/users/:username' do
    if logged_in?
      if current_user.username == params[:username]
        redirect '/profile'
      else
        @user = User.find_by(username: params[:username])
        @friends = @user.friends
        @brackets = @user.brackets.order(created_at: :desc)
        @golds = []
        @brackets.where("champ_name = ?", @user.username).each do |bracket|
          if @user.brackets.include?(bracket)
            @golds << bracket
          end
        end
        @silvers = []
        @brackets.where("runner_up_name = ?", @user.username).each do |bracket|
          if @user.brackets.include?(bracket)
            @silvers << bracket
          end
        end

        erb :'users/view'
      end
    else
      redirect '/login'
    end
  end

end
