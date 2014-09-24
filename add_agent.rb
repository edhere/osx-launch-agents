require 'ripl'

require_relative 'lib/agent.rb'

abort "usage: ruby add_agent.rb absolute_path_to_script" if ARGV.length < 1
script = "#{ARGV[0]}"

if File.file?(script)
  agent = Agent.new(script)
  puts "[INFO] #{agent.id}"
end

Ripl.start