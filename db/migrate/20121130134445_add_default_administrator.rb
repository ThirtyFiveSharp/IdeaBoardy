class AddDefaultAdministrator < ActiveRecord::Migration
  def up
    admin = User.create! do |u|
      u.email = 'ThirtyFive.Sharp@gmail.com'
      u.password = 'admin123#'
      u.password_confirmation = 'admin123#'
    end
    puts 'Admin created with email ThirtyFive.Sharp@gmail.com!'
  end

  def down
    User.delete_all
    puts 'all users are removed!'
  end
end
