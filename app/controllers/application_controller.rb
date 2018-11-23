require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
  end

  use Rack::Flash

  get '/' do
    if logged_in?
      redirect '/profile'
    else
      erb :index
    end
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def redirect_if_not_logged_in
      redirect '/login' if !logged_in?
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def login(username, password)
      user = User.find_by(username: username)
      if user && user.authenticate(password)
        session[:user_id] = user.id
        puts session[:user_id]
      else
        redirect '/login'
      end
    end

    def logout!
      session.clear
    end

    def time_ago_in_words(t1, t2)
      s = t1.to_i - t2.to_i # distance between t1 and t2 in seconds
      resolution = if s > 29030400 # seconds in a year
        [(s/29030400), 'years']
      elsif s > 2419200
        [(s/2419200), 'months']
      elsif s > 604800
        [(s/604800), 'weeks']
      elsif s > 86400
        [(s/86400), 'days']
      elsif s > 3600 # seconds in an hour
        [(s/3600), 'hours']
      elsif s > 60
        [(s/60), 'minutes']
      else
        [s, 'seconds']
      end

      # singular v. plural resolution
      if resolution[0] == 1
        resolution.join(' ')[0...-1]
      else
        resolution.join(' ')
      end
    end
  end

end
