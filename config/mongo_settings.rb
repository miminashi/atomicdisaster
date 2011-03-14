require 'mongoid'

#MONGO_SERVER = '172.16.0.65'
MONGO_SERVER = '127.0.0.1'
MONGO_DB = 'nuc_reactor'

Mongoid.configure do |conf|
  conf.master = Mongo::Connection.new(MONGO_SERVER, 27017).db(MONGO_DB)
end

class Tweet
  include Mongoid::Document
  field :t_id, :type => Integer
  field :from_user, :type => String
  field :profile_image_url, :type => String
  field :text, :type => String
  field :created_at, :type => Time
  field :source, :type => String
end

