require 'bcrypt'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/dev.db")


class User
	include DataMapper::Resource

	attr_accessor :password, :password_confirmation

	property :id,               Serial
	property :email,            String, :required => true, :unique => true#, :format => :email_address
	property :realName,         String, :default => 'Erronious Person' #want this to be manual
	property :password_hash,    Text
	property :password_salt,    Text
	property :token,            String
	property :created_at,       EpochTime
	property :admin,            Boolean, :default => false

	validates_confirmation_of :password

	after :create do
		self.token = SecureRandom.hex
	end

	def generate_token
		self.update!(:token => SecureRandom.hex)
	end

	def admin?
		self.admin
	end

end

DataMapper.finalize
DataMapper.auto_upgrade!
