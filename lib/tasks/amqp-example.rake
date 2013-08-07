desc "Load AmqpExample environment"
task :environment do
  require File.expand_path('config/environment', AmqpExample.root)
end
