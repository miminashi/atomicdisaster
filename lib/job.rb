require 'resque'
#require 'mongoid'
require 'twitter'
require 'config/mongo_settings'
#require 'lib/validator'
require 'config/crawler_settings'

class KillYouSearch
  @queue = :atomicdisaster

  def self.perform
    search = Twitter::Search.new
    search.containing(KEYWORD).per_page(200).each do |r|

      puts r.text

      if Tweet.where(:t_id => r.id).count == 0
        # save all hit status
        m_tweet = Tweet.new do |t|
          t.t_id = r.id
          t.from_user = r.from_user
          t.profile_image_url = r.profile_image_url
          t.text = r.text
          t.created_at = r.created_at
          t.source = r.source
          # set flug if noticed murder
          #if r.text =~ /殺す(\s|$|w|ｗ|わ*よ($|！|？|。)|ぞ|!+$|！+$|。)/u
=begin
          if is_murder?(r.text)
            t.noticedmurder = true
            puts '殺す'
          else
            t.noticedmurder = false
          end
=end
        end
        m_tweet.save
        puts "inserted"
        puts
      end

    end
  end
end

