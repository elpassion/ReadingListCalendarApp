# ReadingListCalendar

![Swift v5.0](https://img.shields.io/badge/swift-v5.0-orange.svg)
![platform macOS](https://img.shields.io/badge/platform-macOS-blue.svg)

**macOS** application that sync **Safari Reading List** items to your **Calendar**.

Inspired by [Tweet by Marcin Krzyżanowski](https://twitter.com/krzyzanowskim/status/1099679842860257280).

![Reading List Calendar App](Misc/screenshot-1.png)

## Roadmap

- [x] MVP - adding reading list items to choosen calendar
- [ ] Automatic synchronization in background

## Setup

Requirements: 

- Xcode 10.2
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Carthage](https://github.com/Carthage/Carthage)

To set up the project, run `setup.sh` in Terminal.

## Develop

Open `ReadingListCalendar.xcodeproj` in Xcode.

### Build targets

|Target|Kind|Description|
|:--|:--|:--|
|`ReadingListCalendarApp`|Cocoa App|Main target of the app|
|`ReadingListCalendarAppTests`|macOS Unit Testing Bundle|App main target's tests|

### Build schemes

|Scheme|Purpose|
|:--|:--|
|`App`|Build, run, test and archive the app|

## License

Copyright © 2019 [EL Passion](https://www.elpassion.com)

License: [GNU GPLv3](LICENSE)
