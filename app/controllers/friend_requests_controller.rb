class FriendRequestsController < ApplicationController

  post '/friend_requests' do
    @exists = User.all.include?(User.find_by(username: params[:pending_friend_name]))
    @already_friends = current_user.friends.include?(User.find_by(username: params[:pending_friend_name]))
    @already_requested = FriendRequest.all.include?(FriendRequest.find_by(user_id: current_user.id, pending_friend_id: User.find_by(username: params[:pending_friend_name])))


    if !@already_friends && !@already_requested && @exists
      @pending_friend_id = User.find_by(username: params[:pending_friend_name]).id
      @friend_request = FriendRequest.create(user_id: current_user.id, pending_friend_id: @pending_friend_id)
      redirect '/profile'
    else
      if @already_friends
        flash[:message] = "You are already friends with #{params[:pending_friend_name]}."
      elsif @already_requested
        flash[:message] = "You already sent #{params[:pending_friend_name]} a friend request."
      elsif !@exists
        flash[:message] = "#{params[:pending_friend_name]} is not a valid user."
      end
      redirect '/profile'
    end
  end

end
