# OSX [LaunchAgents](https://developer.apple.com/library/mac/documentation/macosx/conceptual/bpsystemstartup/chapters/CreatingLaunchdJobs.html)

### installation
```
git clone git@github.com:advectus/osx-launch-agents.git ~/osx-launch-agents

cd ~/osx-launch-agents && bundle install
```

### add agent

```
ruby add_agent.rb ~/bootstrap.sh

>> agent.load
```

### locations on file system

~/Library/LaunchAgents         Per-user agents provided by the user.
/Library/LaunchAgents          Per-user agents provided by the administrator.
/Library/LaunchDaemons         System-wide daemons provided by the administrator.
/System/Library/LaunchAgents   Per-user agents provided by Apple.
/System/Library/LaunchDaemons

### LaunchAgents

```
launchctl list
launchctl remove com.spotify.webhelper
launchctl remove com.evernote.EvernoteHelper

```

### LaunchDaemons

using launchctl
```
cd  /Library/LaunchDaemons
sudo launchctl list | grep ^[0-9]
sudo launchctl bslist | grep ^A
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist
```

### Diagnostics

check information on kernal usage 
```
sudo zprint -t
sudo zprint -t -s | head -n20
```

report on syscalls
```
sudo syscallbypid.d
sudo syscallbysysc.d
```

new processes as they are executed
```
sudo newproc.d
```

new files
```
sudo creatbyproc.d
```

free inactive memory: force completion of pending disk writes, force disk cache to be purged
```
sync && sudo purge
```

apple diagnose
```
sysdiagnose
```
reset SMC
```
http://support.apple.com/en-us/HT201295
```

reset computers PRAM
```
http://support.apple.com/kb/PH18761
```
