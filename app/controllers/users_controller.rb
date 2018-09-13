class UsersController < ApplicationController

  post '/users' do
    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]

    if @user.save
      login(@user.username, @user.password)
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

end
