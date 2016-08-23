class Agent
  attr_accessor :id, :config
  def initialize(exec, id=nil)
    @id = id || "z" <<(0..29).map{ (('a'..'z').to_a + (0..9).to_a).sample }.join
    @pkg = 'com.advectus'
    @template = 'template/com.advectus.template.plist'
    @pwd = Dir.pwd
    @exec = exec

    # if id supplied, get existing launch agent info
    if !id && @exec
      configure
      load
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
    File.open("#{@pwd}/agents/#{@template}",'r') do |f|
      f.each_line do |line|
        config << line.gsub("package_name","#{@pkg}.#{@id}").gsub("script_location","#{@pwd}/agents/#{@id}/exec.sh")
      end
      File.open("#{@pwd}/agents/#{@id}/#{@pkg}.#{@id}.plist", 'w') {|plist| plist.puts config }
      #File.open("#{@pwd}/agents/#{@id}/exec.sh", 'w') do |exec|
      #  exec.puts "#!/bin/bash"
      #  exec.puts "mkdir ~/Desktop/#{@id}"
      #end
      #File.open("#{@pwd}/agents/#{@id}/exec.rb", 'w') do |exec|
      #  exec.puts "#!/bin/ruby"
      #  exec.puts "`mkdir ~/Desktop/#{@id}`"
      #end
      puts "cp #{@exec} #{@pwd}/agents/#{@id}/exec.sh"
      `cp "#{@exec}" "#{@pwd}"/agents/"#{@id}"/exec.sh`
      `chmod a+x "#{@pwd}"/agents/"#{@id}"/exec.sh`
    end
    config
  end
end
