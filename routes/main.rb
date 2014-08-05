get '/' do
  unless cookies[:return]
    cookies[:return] = 'true'
    redirect '/first'
  end
  erb :topology
end

get '/top' do
  redirect '/'
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

get '/first/password' do
  erb "MHN-adminpass".to_sym
end

get '/login' do
  erb "MHN-adminlogin".to_sym
end

get '/parental' do
  erb :parental
end
