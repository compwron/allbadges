
# TODO: curl sort by recent
# json = `curl https://api.github.com/users/#{username}/repos`    
# f = File.open('alldata.json', 'w') {|file| file.puts json}
require 'json'
file = File.read('alldata.json')
j = JSON.parse(file)
username_reponames = j.map {|repo| repo["full_name"].split('/')}

def make_badges username, reponame
	<<-BADGES
	#{username}/#{reponame}
[![Code Climate](https://codeclimate.com/github/#{username}/#{reponame}/badges/gpa.svg)](https://codeclimate.com/github/#{username}/#{reponame})
[![Test Coverage](https://codeclimate.com/github/#{username}/#{reponame}/badges/coverage.svg)](https://codeclimate.com/github/#{username}/#{reponame})
[![Build Status](https://travis-ci.org/#{username}/#{reponame}.svg)](https://travis-ci.org/#{username}/#{reponame})
[![Dependency Status](https://gemnasium.com/#{username}/#{reponame}.png)](https://gemnasium.com/#{username}/#{reponame})
[![Gem Version](https://img.shields.io/gem/v/#{reponame}.svg)](https://rubygems.org/gems/#{reponame})

BADGES
end

badges = username_reponames.map {|pair|
	username = pair.first
	reponame = pair.last
	make_badges(username, reponame)
}

File.open('badges.md', 'w') {|file| file.puts badges}
p badges