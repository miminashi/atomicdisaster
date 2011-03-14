#!/usr/bin/env ruby -Ku
#require 'logger'

require "rubygems"
require "bundler/setup"

$KCODE = 'UTF8'

WORKER_LOGFILE = 'log/resque_worker.log'
WORKER_PIDFILE = 'tmp/resque_worker.pid'
SCHEDULER_LOGFILE = 'log/resque_schedule.log'
SCHEDULER_PIDFILE = 'tmp/resque_schedule.pid'

=begin
# Prepare resque worker
# ワーカーノ ジュンビヲ シマス
if File.exist?(WORKER_PIDFILE)
  #pid = File.open(PIDFILE) {|f| f.read}
  #exec "kill -KILL #{pid}"
  puts "worker already running"
else
  puts "starting worker"
  system "VVERBOSE=true QUEUE=default rake resque:work >#{WORKER_LOGFILE} 2>&1 & echo $! >#{WORKER_PIDFILE}"
  puts "worker started"
end
=end

=begin
# Prepare resque scheduler
# スケジューラノ ジュンビヲ シマス
if File.exist?(SCHEDULER_PIDFILE)
  #pid = File.open(PIDFILE) {|f| f.read}
  #exec "kill -KILL #{pid}"
  puts "scheduler already running"
else
  puts "starting scheduler"
  system "rake resque:scheduler >#{SCHEDULER_LOGFILE} 2>&1 & echo $! >#{SCHEDULER_PIDFILE}"
  puts "scheduler started"
end
=end

require 'resque/server'
require 'lib/killyou'

use Rack::ShowExceptions

# Set the AUTH env variable to your basic auth password to protect Resque.
AUTH_PASSWORD = ENV['AUTH']
if AUTH_PASSWORD
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == AUTH_PASSWORD
  end
end

run Rack::URLMap.new("/" => KillYouApp.new, "/resque" => Resque::Server.new)

