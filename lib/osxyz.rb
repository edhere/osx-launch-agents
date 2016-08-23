require 'fileutils'
require 'json'
require 'osxyz/agent'
require 'osxyz/version'

module Osxyz
  AGENTS_DIR = "#{Dir.pwd}/agents"

  def self.list(params)
    puts "list"
    plists.keys.each do |key|
      puts "#{key}"
      plists[key].each do |plist|
        puts " --> #{plist}"
      end
    end
  end

  def self.add_agent(params)
    raise Exception if !File.exist?(params.first)
    agent = Agent.new
    agent.write_plist
    agent.start(params[0])
  end

  def self.remove_agent(params)
    raise Exception if params.first.nil?
    puts params[0]
    agent = Agent.new(params[0])
    agent.destroy_plist
    agent.stop
  end

  def self.list_agents(params)
    agents.each do |agent|
      puts " --> #{agent}"
    end
  end

  private

  def self.agents
    @agents ||= JSON.load(File.read("#{AGENTS_DIR}/agents.json"))["agents"]
  end

  def self.plists
    @plists ||= begin
      plists = {}
      dirs.each do |dir|
        plists[dir] ||= []
        Dir["#{File.expand_path(dir)}/*.plist"].each do |plist|
          plists[dir] << plist
        end
      end
      plists
    end
  end

  def self.dirs
    [
      "~/Library/LaunchAgents",
      "/Library/LaunchAgents",
      "/Library/LaunchDaemons",
      "/System/Library/LaunchAgents",
      "/System/Library/LaunchDaemons"
    ]
  end

end
