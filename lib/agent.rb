class Agent
  attr_accessor :id, :config
  def initialize(id=nil)
  	@id = id || "z" <<(0..29).map{ (('a'..'z').to_a + (0..9).to_a).sample }.join
  	@pkg = 'com.advectus'
  	@pwd = Dir.pwd

    # if id supplied, get existing launch agent info
    if !id
      configure
    end
  end
  def test
  	`launchctl start ~/Library/LaunchAgents/"#{@pkg}"."#{@id}"`
  end
  def load
    `cp #{@pwd}/agents/#{@id}/#{@pkg}.#{@id}.plist ~/Library/LaunchAgents/"#{@pkg}"."#{@id}.plist"`
    `launchctl load ~/Library/LaunchAgents/"#{@pkg}"."#{@id}.plist"`
    true
  end

  private
  def configure
    config = ""
    @plist = `mkdir #{@pwd}/agents/#{@id}`
    File.open("#{@pwd}/agents/template/com.advectus.template.plist",'r') do |f|
      puts f
      f.each_line do |line|
        puts line
        if line.include? "package_name"
          config << line.gsub("package_name","#{@pkg}.#{@id}")
        elsif line.include? "script_location"
          config << line.gsub("script_location","#{@pwd}/agents/#{@id}/exec.sh")
        else
          config << line
        end
      end
      File.open("#{@pwd}/agents/#{@id}/#{@pkg}.#{@id}.plist", 'w') {|plist| plist.puts config }
      File.open("#{@pwd}/agents/#{@id}/exec.sh", 'w') do |exec|
        exec.puts "#!/bin/bash"
        exec.puts "mkdir ~/Desktop/#{@id}"
      end
      `chmod a+x "#{@pwd}"/agents/"#{@id}"/exec.sh`
    end
    config
  end
end
