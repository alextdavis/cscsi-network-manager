get '/' do
  erb :home
end

get '/network' do
  erb :network
end

get '/first' do
  erb "MHN-firstsetup"
end

get '/router' do
  erb "MHN-topologyrouter"
end
