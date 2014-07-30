require 'rubygems'
require 'bundler'

$stdout.sync = true #supposedly helps with heroku logging?

Bundler.require

require './bar_builder.rb'

configure do
  set :template_engine, :erb
  use Rack::Session::Cookie, :secret => rand(100000000).to_s + 'thisisVdDVdsjvILEWIVOo37279'
  set :protection, :session => true
end

puts 'STARTING!!!'

require './helpers'
require './models'
Dir['./routes/*.rb'].each { |file| require file }

require './bar_config'

run Sinatra::Application