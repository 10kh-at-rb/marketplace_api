namespace :db do
  desc "Set all user.name fields to user.email"
  task update_usernames: :environment do
    User.connection.execute("UPDATE users SET name = email") 
  end
end
