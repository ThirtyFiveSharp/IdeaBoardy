task :heroku => ['db:migrate', 'precompile'] do
  `bundle exec rails server thin -p $PORT -e $RACK_ENV`
end