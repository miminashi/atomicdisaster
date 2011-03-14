require 'pp'
#require 'rubygems'
#require 'twitter'
require 'sinatra/base'
require 'erb'
#require 'resque'
#require 'resque_scheduler'
#require 'job.rb'
require 'config/mongo_settings'
require 'will_paginate/view_helpers/base'
require 'will_paginate/view_helpers/link_renderer'
#require 'will_paginate/view_helpers/action_view'
#require 'will_paginate/view_helpers/base'

#WORKER_LOGFILE = 'resque_worker.log'
#WORKER_PIDFILE = 'resque_worker.pid'
#SCHEDULER_LOGFILE = 'resque_schedule.log'
#SCHEDULER_PIDFILE = 'resque_schedule.pid'

WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected
  def url(page)
    url = @template.request.url
    if page == 1
      # strip out page param and trailing ? if it exists
      url.gsub(/page=[0-9]+/, '').gsub(/\?$/, '')
    else
      if url =~ /page=[0-9]+/
        url.gsub(/page=[0-9]+/, "page=#{page}")
      else
        url + "?page=#{page}"
      end      
    end
  end
end

class KillYouApp < Sinatra::Base
  configure do
    enable :dump_errors
    enable :sessions
    set :public, './public'
  end

  helpers WillPaginate::ViewHelpers::Base

  get '/' do
    redirect '/tweets'
  end

  get '/tweet/:t_id' do

  end

  get '/tweets' do
    @tweets = Tweet.desc(:t_id).paginate(:page => params[:page], :per_page => 13)
    #@tweets = Tweet.paginate(:page => params[:page], :per_page => 10, :sort => [:t_id, :desc])
    #puts "total_pages: #{@tweets.total_pages}"
    #p @prev
    #p @next
    erb :page
  end

  get '/effect' do
    erb :effect
  end

  get '/changes' do
    erb :changes
  end

  get '/statistics' do
    erb :statistics
  end

  get '/search' do
    erb :search
  end
end

at_exit do
  # shutdown scheduler
  if File.exist?(SCHEDULER_PIDFILE)
    pid = File.open(SCHEDULER_PIDFILE) {|f| f.read}
    system "kill #{pid}"
    File.delete(SCHEDULER_PIDFILE)
    puts "scheduler shutdown"
  else
    puts "scheduler may not running"
  end

  # shutdown worker
  if File.exist?(WORKER_PIDFILE)
    pid = File.open(WORKER_PIDFILE) {|f| f.read}
    system "kill #{pid}"
    File.delete(WORKER_PIDFILE)
    puts "worker shutdown"
  else
    puts "worker may not running"
  end
end

