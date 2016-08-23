module Osxyz
  class Agent

    def initialize(agent_plist=nil)
      @agent_plist = agent_plist
    end

    def start(path)
      `cp "#{File.expand_path(path)}" "#{agent_dir}"/exec.sh`
      `chmod a+x "#{agent_dir}"/exec.sh`
      `cp "#{agent_dir}/#{plist}" ~/Library/LaunchAgents/"#{plist}"`
      `launchctl load ~/Library/LaunchAgents/"#{plist}"`
    end

    def stop
      raise Exception if @agent_plist.nil?
      `launchctl unload ~/Library/LaunchAgents/"#{@agent_plist}"`
      `rm -f ~/Library/LaunchAgents/"#{@agent_plist}"`
    end

    def write_plist
      FileUtils.mkdir_p(agent_dir) if !File.exist?(agent_dir)
      File.open("#{agent_dir}/#{plist}", 'w') {|plist| plist.puts config }
      agents = JSON.load(File.read("#{agents_dir}/agents.json"))
      agents["agents"] << "#{plist}"
      File.write("#{agents_dir}/agents.json", JSON.pretty_generate(agents))
    end

    def destroy_plist
      raise Exception if @agent_plist.nil?
      agent_id = @agent_plist.split("#{pkg}.").last.split(".plist").first
      agents = JSON.load(File.read("#{agents_dir}/agents.json"))
      agents["agents"].delete "#{@agent_plist}"
      File.write("#{agents_dir}/agents.json", JSON.pretty_generate(agents))
      `rm -rf "#{agents_dir}/#{agent_id}"`
    end

    private

    def id
      @id ||= "z" <<(0..29).map{ (('a'..'z').to_a + (0..9).to_a).sample }.join
    end

    def config
      config = ""
      File.open("#{template_dir}/#{template}",'r') do |f|
        f.each_line do |line|
          config << line.gsub("package_name","#{pkg}.#{id}").gsub("script_location","#{agent_dir}/exec.sh")
        end
      end
      config
    end

    def agents_dir
      Osxyz::AGENTS_DIR || "#{Dir.pwd}/agents"
    end

    def agent_dir
      "#{agents_dir}/#{id}"
    end

    def template_dir
      "#{agents_dir}/template"
    end

    def plist
      "#{pkg}.#{id}.plist"
    end

    def pkg
      'com.advectus'
    end

    def template
      'com.advectus.template.plist'
    end

  end
end
