class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do|t|
  		t.string :fname
  		t.string :lname
  		t.string :hometown
  		t.string :state
  		t.string :country
  		t.string :email
  		t.datetime :created_at
  		t.integer :user_id
  	end
  end
end