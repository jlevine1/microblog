require 'sinatra'
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:example3.sqlite3"}

require './models'
require 'bundler/setup'
require 'rack-flash'

set :sessions, true
use Rack::Flash, :sweep=>true

def current_user
	if session[:user_id]
		@current_user=User.find(session[:user_id])
	end
end

get '/' do
	redirect '/sign-in'
end

get '/sign-in' do
	erb :sign_in
end

post '/sign-in-process' do
	@user=User.find_by_username params[:username]
	if @user && @user.password==params[:password]
		flash[:message]="You have inserted yourself into the cream."
		session[:user_id]=@user.id
		redirect '/home'
	else
		flash[:message]="You have been rejected by the cream. Please try again."
		redirect '/sign-in'
	end
end

get '/sign-up' do
	erb :sign_up
end

post '/sign-up-process' do
	User.create()
	Profile.create()
	@profile = Profile.last
	@user = User.last
	@profile.fname=params[:fname]
	@profile.lname=params[:lname]
	@profile.email=params[:email]
	@user.username=params[:username]
	@user.password=params[:password]
	@profile.hometown=params[:hometown]
	@profile.state=params[:state]
	@profile.country=params[:country]
	@profile.user_id=@user.id
	@user.save
	@profile.save
	redirect '/sign-in'
end

get '/edit-profile' do
	erb :edit_profile
end

post '/edit-profile-process' do
	current_user
	puts @current_user.id
	@profile=User.find(@current_user.id).profile
	@profile.fname=params[:fname]
	@profile.lname=params[:lname]
	@profile.email=params[:email]
	@current_user.password=params[:password]
	@profile.hometown=params[:hometown]
	@profile.state=params[:state]
	@profile.country=params[:country]
	@current_user.save
	@profile.save
	redirect '/home'
end

get '/delete-account' do
	User.destroy(session[:user_id])
	Profile.destroy(session[:user_id])
	redirect '/sign-in'
end

get '/user/:id' do 
	@current_user=User.find(params[:id]);
	@current_profile=Profile.find_by_user_id(params[:id])
	erb :profile
end

get '/sign-out' do
	session[:user_id]=nil
	flash[:message]="You have pulled out of the cream."
	redirect '/sign-in'
end

get '/posts' do
	@post=Post.all()
	erb :posts
end

get '/new-post' do
	erb :new_post
end

post '/post-process' do
	a = Profile.find_by_user_id(session[:user_id]);
	Post.create(data:params[:content], author:(a.fname + " " + a.lname))
	redirect '/posts'
end

get '/home' do
	@current_user=User.find(session[:user_id])
	@profile=User.find(@current_user.id).profile
	erb :home
end

get '/profile' do
	@current_profile=Profile.find_by_user_id(session[:user_id])
	@current_user=User.find(session[:user_id])
	erb :profile
end