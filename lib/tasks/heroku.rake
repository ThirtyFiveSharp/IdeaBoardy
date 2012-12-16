task :heroku => ['db:migrate'] do
  `bundle exec rails server thin -p $PORT -e $RACK_ENV`
end