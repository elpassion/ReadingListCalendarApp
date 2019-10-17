# ReadingListCalendar

![Swift v5.1](https://img.shields.io/badge/swift-v5.1-orange.svg)
![platform macOS](https://img.shields.io/badge/platform-macOS-blue.svg)
![code coverage 100%](https://img.shields.io/badge/covergage-100%25-success.svg)

**macOS** application that sync **Safari Reading List** items to your **Calendar**.

Inspired by [Tweet by Marcin Krzyżanowski](https://twitter.com/krzyzanowskim/status/1099679842860257280).

![Reading List Calendar App](Misc/screenshot-1.png)

## Install

- macOS 10.15 or newer is required (last version that supports macOS 10.14 is [v1.0.2](https://github.com/elpassion/ReadingListCalendarApp/releases/tag/v1.0.2_3))
- Download latest version from [releases page](https://github.com/elpassion/ReadingListCalendarApp/releases)
- Unzip archive and copy `Reading List Calendar.app` to `/Applications` folder
- Start the app and configure it for your needs
- Optionally, to setup automatic sync in background, follow [wiki page](https://github.com/elpassion/ReadingListCalendarApp/wiki)

## Launch arguments

Application accepts following (optional) launch arguments:

|Argument|Description|
|:--|:--|
|`-sync`|Start synchronization on app launch|
|`-headless`|Do not present UI and terminate when synchronization completes (to use with `-sync` argument)|

You can start the app with above arguments using `open` command:

```sh
open -a "Reading List Calendar" --args -sync -headless
```

## Roadmap

- [x] MVP - adding reading list items to choosen calendar
- [x] Automatic synchronization in background (using launch arguments)
- [x] Migrate from RxSwift to Combine
- [ ] UI for configuring automatic synchronization in background

## Develop

### Requirements

- Xcode 11.1
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Carthage](https://github.com/Carthage/Carthage)

### Setup

- Run `setup.sh` in Terminal
- Open `ReadingListCalendar.xcodeproj` in Xcode

### Build targets

|Target|Kind|Description|
|:--|:--|:--|
|`ReadingListCalendarApp`|Cocoa App|Main target of the app|
|`ReadingListCalendarAppTests`|macOS Unit Testing Bundle|App main target's tests|

### Build schemes

|Scheme|Purpose|
|:--|:--|
|`ReadingListCalendar`|Build, run, test and archive the app|

## License

Copyright © 2019 [EL Passion](https://www.elpassion.com)

License: [GNU GPLv3](LICENSE)
