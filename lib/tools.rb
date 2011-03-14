$KCODE = 'u'

require 'pp'
require 'rubygems'
require 'config/mongo_settings'
require 'lib/murder_validator'

def destroy_invalid
  p Tweet.where(:t_id => nil).count
  Tweet.destroy_all(:conditions => {:t_id => nil})
  p Tweet.where(:t_id => nil).count
end

def repair_noticedmurder
  p Tweet.where(:noticedmurder => nil).count
  Tweet.where(:noticedmurder => nil).limit(1000).each do |r|
    #if r.text =~ /殺す(\s|$|w|ｗ|わ*よ($|！|？|。)|ぞ|!+$|！+$|。)/u
    if is_murder?(r.text)
      r.update_attributes(:noticedmurder => true)
    else
      r.update_attributes(:noticedmurder => false)
    end
  end
  p Tweet.where(:noticedmurder => nil).count
end

=begin
def destroy_dupulicated
  r = Tweet.all.desc(:t_id).first
  t_id = r.t_id
  puts t_id
  while(r = _destroy_dupulicated(t_id))
    t_id = r.t_id
  end
end

def _destroy_dupulicated(t_id)
  if Tweet.where(:t_id => t_id).count > 1
    puts "t_id: #{t_id}" 
    ra = Tweet.where(:t_id => t_id).desc(:id).to_a
    puts "before"
    pp ra
    ra[1...ra.size].each do |r|
      r.destroy
    end
    puts
    puts "after"
    pp Tweet.where(:t_id => t_id).to_a
    #print "press enter"
    #gets
    puts
    puts
  end
  r = Tweet.desc(:t_id).where(:t_id.lt => t_id).first
  return r
end
=end

def destroy_dupulicated
  m = File.open('lib/mapreduce/destroy_dupulicated/map.js') {|f| f.read }
  r = File.open('lib/mapreduce/destroy_dupulicated/reduce.js') {|f| f.read }
  res = Tweet.collection.mapreduce(m, r)
  puts "#{res.count} tweets exists"
  duplicated = []
  res.find().each do |r|
    duplicated << r["_id"] if r["value"] > 1
  end
  puts "#{duplicated.size} tweets duplicated"

  duplicated.each do |d|
    ra = Tweet.where(:t_id => d).desc(:id).to_a
    puts "t_id: #{d}: #{ra.size}"
    ra[1...ra.size].each do |r|
      r.destroy
    end
  end
end

