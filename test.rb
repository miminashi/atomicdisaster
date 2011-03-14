WORKER_LOGFILE = 'resque_worker.log'
WORKER_PIDFILE = 'resque_worker.pid'
SCHEDULER_LOGFILE = 'resque_schedule.log'
SCHEDULER_PIDFILE = 'resque_schedule.pid'

# Prepare resque worker
if File.exist?(WORKER_PIDFILE)
  puts "worker already running"
else
  puts "starting worker"
  system "VVERBOSE=true QUEUE=default rake resque:work >#{WORKER_LOGFILE} 2>&1 & echo $! >#{WORKER_PIDFILE}"
  puts "worker started"
end

# Prepare resque scheduler
if File.exist?(SCHEDULER_PIDFILE)
  puts "scheduler already running"
else
  puts "starting scheduler"
  system "rake resque:scheduler >#{SCHEDULER_LOGFILE} 2>&1 & echo $! >#{SCHEDULER_PIDFILE}"
  puts "scheduler started"
end

