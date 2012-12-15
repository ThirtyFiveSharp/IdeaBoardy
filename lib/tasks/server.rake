namespace :server do
  task :dev => ['db:migrate', 'assets:clean'] do
    puts "starting WebBrick server on port 3000..."
    %x[rails server]
  end

  task :prod => ['db:migrate', 'assets:clean', 'assets:precompile'] do
    puts "starting thin server on port 3001..."
    %x[rails server thin -e=production -p 3001]
  end
end