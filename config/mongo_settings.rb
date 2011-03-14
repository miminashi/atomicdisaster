require 'mongoid'

#MONGO_SERVER = '172.16.0.65'
MONGO_SERVER = '127.0.0.1'
MONGO_DB = 'nuc_reactor'

Mongoid.configure do |conf|
  conf.master = Mongo::Connection.new(MONGO_SERVER, 27017).db(MONGO_DB)
end

class Tweet
  include Mongoid::Document
  field :t_id
  field :from_user
  field :profile_image_url
  field :text
  field :created_at
  field :source
end

