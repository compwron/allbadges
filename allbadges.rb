if ARGV.size != 1
	puts "Usage: ruby allbadges.rb <github username>"
	exit
end	
username = ARGV[0]
data_file = "tmp/#{username}_data.json"

unless File.exist?(data_file)
	json = `curl https://api.github.com/users/#{username}/repos?sort=created`    
	f = File.open(data_file, 'w') {|file| file.puts json}
end

data = File.read(data_file)

require 'json'
j = JSON.parse(data)

badges_data = j.map { |repo| 
	repo["full_name"].split('/')
}.map { |pair|
	username = pair.first
	reponame = pair.last
	<<-BADGES
	#{username}/#{reponame}
[![Code Climate](https://codeclimate.com/github/#{username}/#{reponame}/badges/gpa.svg)](https://codeclimate.com/github/#{username}/#{reponame})
[![Test Coverage](https://codeclimate.com/github/#{username}/#{reponame}/badges/coverage.svg)](https://codeclimate.com/github/#{username}/#{reponame})
[![Build Status](https://travis-ci.org/#{username}/#{reponame}.svg)](https://travis-ci.org/#{username}/#{reponame})
[![Dependency Status](https://gemnasium.com/#{username}/#{reponame}.png)](https://gemnasium.com/#{username}/#{reponame})
[![Gem Version](https://img.shields.io/gem/v/#{reponame}.svg)](https://rubygems.org/gems/#{reponame})

BADGES
}

badges_file = "output/#{username}_badges.json"
File.open(badges_file, 'w') { |file| file.puts badges_data }

puts "Wrote badge data to #{badges_file}"