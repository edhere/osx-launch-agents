
require 'ripl'

require_relative 'lib/agent.rb'

agent = Agent.new
puts agent.id

Ripl.start