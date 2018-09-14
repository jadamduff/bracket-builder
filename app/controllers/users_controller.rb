class UsersController < ApplicationController

  get '/profile' do
    if logged_in?
      @user = current_user
      @friend_requests = FriendRequest.where("pending_friend_id = ?", @user.id)
      @friends = @user.friends
      @brackets = @user.brackets
      @golds = @brackets.where("champ_id = ?", @user.id)
      @silvers = @brackets.where("runnder_up_id = ?", @user.id)
      erb :'/users/show'
    else
      redirect "/login"
    end
  end

  post '/users' do
    if User.find_by(username: params[:username]) == nil && User.find_by(email: params[:email]) == nil
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
      end
      redirect '/'
    end
  end

end
