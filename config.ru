require './config/environment'

use Rack::MethodOverride
use UsersController
use SessionsController
use BracketsController
use FriendRequestsController
use FriendshipsController
run ApplicationController
