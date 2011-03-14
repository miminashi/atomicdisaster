require 'resque'
require 'resque/tasks'
require 'resque_scheduler'
require 'resque_scheduler/tasks'
require 'lib/job'
#task "resque:scheduler_setup" => :environment
Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), 'config/resque_schedule.yml'))

