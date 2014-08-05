get '/' do
  erb :home
end

get '/top' do
  erb :topology
end

get '/network' do
  erb :network
end

get '/first' do
  redirect '/first/network'
end

get '/first/network' do
  erb "MHN-firstsetup".to_sym
end

get '/first/info' do
  erb "MHN-firsttimeinfo".to_sym
end

get '/login' do
  erb "MHN-adminlogin".to_sym
end

get '/first/password' do
  erb "MHN-adminpass".to_sym
end
