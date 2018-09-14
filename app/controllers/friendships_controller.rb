class FriendshipsController < ApplicationController

  post '/friendships' do
    if logged_in?
      @friend_request = FriendRequest.find(params[:friend_request_id])
      @requester = User.find(@friend_request.user_id)
      if current_user.id == @friend_request.pending_friend_id
          current_user.friends << @requester
          @requester.friends << current_user
          @friend_request.delete
      else
        flash[:message] = "Unable to accept friend request."
      end
      redirect '/profile'
    else
      redirect '/login'
    end
  end

  delete '/friendships/:friend_id/delete' do
    if logged_in?
      @friend = User.find(params[:friend_id])
      Friendship.delete(current_user.friendships.where("user_id = ? OR friend_id = ?", params[:friend_id], params[:friend_id]))
      Friendship.delete(@friend.friendships.where("user_id = ? OR friend_id = ?", current_user.id, current_user.id))
      redirect '/profile'
    else
      redirect '/login'
    end
  end

end
