require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/em-http-oauth-request'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'em-http-oauth-request' do
  self.developer 'Draconis Software', 'info@draconis.com'
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['oauth','>= 0.3.6'], ['em-http-request', '>= 0.2.4']]
  self.summary = 'Allows em-http-request to be used for OAuth requests.'
  self.url = 'http://github.com/draconis/em-http-oauth-request'
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
