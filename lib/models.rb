require './models/application_record'

Dir["./models/*.rb"].each do |file| 
  next if file.match(/application\_record\.rb\Z/)
  require file
end
