# Installation

Read how to install *Instruments* library and link it to your projects.

## Swift Package Manager

The *Instruments* library is available via [Swift Package Manager](https://swift.org/package-manager/).

##### Linking to an Xcode project

- Go to `File` -> `Add Packages...` 
- Type package URL [https://github.com/InstrumentBox/Instruments](https://github.com/InstrumentBox/Instruments)
- Select `Instruments` package, specify dependency rule, and click `Add Package`
- Select `Instruments` target and click `Add Package`

##### Linking to a Swift package

Add the following lines to your `Package.swift` file:

```swift
let package = Package(
   ...,
   dependencies: [
      ...,
      .package(url: "https://github.com/InstrumentBox/Instruments", .upToNextMajor(from: "1.0.0")
   ],
   ...
)
```

## Git Submodule

- Open Terminal and `cd` to your project top-level directory

- Add *Instruments* package as git [submodule](https://git-scm.com/docs/git-submodule) by running the
  following command

```sh
$ git submodule add https://github.com/InstrumentBox/Instruments.git
```

- Go to Xcode and select `File` -> `Add Packages...`
- Click `Add Local...`
- Select `Instruments` directory
- Next, select your application project in the Project Navigator (blue project icon) to navigate 
  to the target configuration window and select the application target under the "Targets" heading 
  in the sidebar.
- In the tab bar at the top of that window open the "General" panel.
- Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
- Select *Instruments* library

## Manual Installation

If you prefer not to use Swift Package Manager or git submodules, you can  integrate  *Instruments* into 
your project manually.

- Download the repository at [https://github.com/InstrumentBox/Instruments](https://github.com/InstrumentBox/Instruments)
- Unzip archive
- Copy all `*.swift` files from `Sources/Instruments` to your project
- Go to Xcode and select `File` -> `Add Files to "<Project Name>"...`
- Select recently copied files

## Carthage

Carthage is not supported. From now on, Swift Package Manager should be the preferred dependency 
management tool.

## CocoaPods

CocoaPods are not supported. From now on, Swift Package Manager should be the preferred dependency 
management tool.
