get '/' do
  erb :home
end

get '/network' do
  html :network
end

get '/first' do
  html "MHN-firstsetup"
end

get '/router' do
  html "MHN-topologyrouter"
end
