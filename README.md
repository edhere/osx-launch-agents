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

### LaunchAgents

```
launchctl list
launchctl remove com.spotify.webhelper
launchctl remove com.evernote.EvernoteHelper

```

### LaunchDaemons

```
cd  /Library/LaunchDaemons
launchctl remove com.LaCie.LRMService.plist
```
