# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JamitLabs/ProjLint. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Getting Started

This section will tell you how you can get started contributing to ProjLint.

### Prerequisites

Before you start developing, please make sure you have the following tools installed on your machine:

- Xcode 9.4+
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Beak](https://github.com/yonaskolb/Beak)
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery)

### Useful Commands

In order to generate the **Xcode project** to develop within, run this command:

```
swift package generate-xcodeproj
```

To check if all **tests** are passing correctly:

```
swift test
```

To check if the **linter** shows any warnings or errors:

```
swiftlint
```

Alternatively you can also add `swiftlint` as a build script to the target `ProjLintKit` so warnings & errors show off right within Xcode when building. (Recommended)

To **create a new rule** with options and tests preconfigured:

```
beak run generateRule --identifier my_new_rule
```

This will add a `Rule` and an `Option` file to the `ProjLintKit` target as well as tests for both and integrate the rule in the `RuleFactory` so it is correctly identified by ProjLint. The generated files include `TODO` comments for the task to be completed in order for the rule to work.

To **update the Linux tests** (required after adding/renaming/removing test methods):

```
beak run generateLinuxMain
```

This will make sure the Linux CI can also find and run all the tests.

### Development Tips

#### Debugging with Xcode
To run the ProjLint tool right from within Xcode for testing, remove the line

```swift
cli.goAndExit()
```

from the file at path `Sources/ProjLint/main.swift` and replace it with:

```swift
cli.debugGo(with: "projlint lint -v")
```

Now, when you choose the `ProjLint` scheme in Xcode and run the tool, you will see the command line output right within the Xcode console and can debug using breakpoints like you normally would.

Beware though that the tool will run within the product build directory, which might look something like this:

```
/Users/YOU/Library/Developer/Xcode/DerivedData/ProjLint-aayvtbwcxecganalwqrvbfznkjke/Build/Products/Debug
```

You can print the exact directory of your Xcode by running:

```swift
FileManager.default.currentDirectoryPath
```

To test a specific ProjLint configuration just create a `.projlint.yml` file within that directory and place your example project to check there, too.

### Commit Messages

Please also try to follow the same syntax and semantic in your **commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/)).
