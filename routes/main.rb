get '/' do
  erb :home
end

get '/network' do
  html :network
end

get '/first' do
  html "MHN-firstsetup"
end
