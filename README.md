# ReadingListCalendar

![Swift v5.0](https://img.shields.io/badge/swift-v5.0-orange.svg)
![platform macOS](https://img.shields.io/badge/platform-macOS-blue.svg)
![code coverage 100%](https://img.shields.io/badge/covergage-100%25-success.svg)

**macOS** application that sync **Safari Reading List** items to your **Calendar**.

Inspired by [Tweet by Marcin Krzyżanowski](https://twitter.com/krzyzanowskim/status/1099679842860257280).

![Reading List Calendar App](Misc/screenshot-1.png)

Application accepts following launch arguments:

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
- [ ] UI for configuring automatic synchronization in background

## Develop

Requirements: 

- Xcode 11.1
- [SwiftLint](https://github.com/realm/SwiftLint)

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
