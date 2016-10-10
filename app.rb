require './environment'

class App < Sinatra::Base
  enable :sessions
  set :erb, layout_options: { views: 'views' }

  get '/' do
    erb :index
  end  
end