task :heroku => 'db:migrate' do
  `bundle exec rails server -p $PORT`
end