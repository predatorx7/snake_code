# About

(NEEDS MORE INFORMATION)
The user will open a folder which the editor will recognize as project. User can browse & edit files in the project.

## How & what we will do

For graphical outputs in Termux, we can implement something similar like VNC viewer or TMUX desktop emulator and export DISPLAY=:1, then we can test Tkinter in Termux

We’ll have to use Containers per project like [LXC](https://linuxcontainers.org/) or [bubblewrap](https://github.com/containers/bubblewrap) so they don’t fuck with other stuff

We’ll use [this API from dart to execute a shell](https://api.dart.dev/stable/2.7.2/dart-io/Process/run.html). We have to construct a Class to wrap Dart’s Process.run API and provide an easy interface to use it from our emulator or debugger.

Working files should be opened like tabs on chrome and the UI should be like a more mobile version of vscode

Apart from UI, the main issue will be recommendations (intellicode), suggestions and clipboard context menu.

For the clipboard context menu, we can make our own widget ([reference](https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9)) and just use android’s copy & paste API.

### List of open-source emulators for android (if we’ll use any)

https://github.com/jackpal/Android-Terminal-Emulator
https://github.com/termux/termux-app

## For Plugin support

- Plugin Architecture for a file written In Dart is not possible.
- Part of the AOT compilation preparing your app for upload to the stores is a tree-shaking, removing everything that isn't needed by the current build. 
- Anything your plugin would need to call is gone.

Instead, we can use another language, [flutter_liquidcore](https://pub.dev/packages/flutter_liquidcore) provides a limited Javascript/Node.js runtime through which we can implement this feature.
