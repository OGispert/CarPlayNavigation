# CarPlayNavigation
A start project to load some content in CarPlay app

Currently working in Xcode 10.3, apparently the delegate method that controls CarPlay lifecycle was deprecated in iOS13


CarPlay is supported by default when you run Simulator. However, you should configure the Simulator with extra options when developing a CarPlay navigation app. 

To enable extra options, enter the following command in Terminal before launching Simulator: 

defaults write com.apple.iphonesimulator CarPlayExtraOptions -bool YES
