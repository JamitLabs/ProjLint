<p align="center">
    <img src="https://raw.githubusercontent.com/JamitLabs/ProjLint/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/0b051a51c12124b7">
        <img src="https://app.bitrise.io/app/0b051a51c12124b7/status.svg?token=riIJ81rKJYiKLNufYx7BZQ&branch=stable"
             alt="Build Status">
    </a>
    <a href="https://codebeat.co/projects/github-com-jamitlabs-projlint">
        <img src="https://codebeat.co/badges/<TODO>"
             alt="Codebeat Badge">
    </a>
    <a href="https://github.com/JamitLabs/ProjLint/releases">
        <img src="https://img.shields.io/badge/Version-0.1.0-blue.svg"
             alt="Version: 0.1.0">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.1-FFAC45.svg"
         alt="Swift: 4.1">
    <img src="https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux-FF69B4.svg"
        alt="Platforms: macOS | Linux">
    <a href="https://github.com/JamitLabs/ProjLint/blob/stable/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
              alt="License: MIT">
    </a>
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>

# ProjLint

Project Linter to lint & autocorrect your non-code best practices.

## Requirements

- Xcode 9.3+ and Swift 4.1+
- Xcode Command Line Tools (see [here](http://stackoverflow.com/a/9329325/3451975) for installation instructions)

## Installation

### Using [Mint](https://github.com/yonaskolb/Mint):

To **install** ProjLint simply run this command:

```shell
$ mint install JamitLabs/ProjLint
```

To **update** to the newest version of TranslationManager when you have an old version already installed run:

```shell
$ mint update JamitLabs/ProjLint
```

## Usage

The TranslationManager provides the following sub commands:
- **`lint`**: Lints the current directory and shows warnings and errors as console output. Has option `--xcode` (or `-x`) to show warnings/errors within Xcodes project navigator.
- **`correct`**: Corrects all correctable violations in the current directory.

**Shared Flags:**
- `--verbose`, `-v`: Prints out more detailed information about steps taken.

**Lint-only Flags:**
- `--xcode`, `-x`: Output are done in a format that is compatible with Xcode – for usage in Build Scripts.
- `--timeout`, `-t`: Seconds to wait for network requests until skipped.
- `--ignore-network-errors`, `-i`: Ignores network timeouts or missing network connection errors.

NOTE: It is recommended to set the options `--timeout 2` and `--ignore-network-errors` if you plan to run `projlint lint` automatically on every build. Otherwise your build time might increase significantly on bad/missing internet connections.

### Configuration

To configure the checks ProjLint does for you, you need to have a YAML configuration file named `.projlint.yml` in the current directory. In there, you have the following sections:

- [`Default Options`](#default-options): Documented below, these options are applied to all rules unless they override them specifically.
- [`Rules with Options`](#rules-with-options): The list of rules to check & correct when the appropriate tasks are run with ability to customize them.
- [`Shared Variables`](#shared-variables): Define String variables to be replaced in rule options using structure `<:var_name:>`.

#### Default Options

The following default options are available:

Option | Type | Required? | Description
--- | --- | --- | ---
`lint_fail_level` | `String` | no | One of `warning` or `error` – specifies when the `lint` command should fail.
`forced_violation_level` | `String` | no | One of `warning` or `error` – enforces the specified level on all violations.

All default options can be overridden by specifying a different value within the rule options. Here's an example:

```yaml
default_options:
  lint_fail_level: error 
```

#### Rules with Options

A list of all currently available rules and their options can be found in the [Rules.md](https://github.com/JamitLabs/ProjLint/blob/stable/Rules.md) file. The structure of how rules can be configures looks like the following:

```yaml
rules:
  - file_existence: # rule identifier
      forced_violation_level: warning # override default option
      paths: # note the additional indentation # rule option
        - .swiftlint.yml
        - README.md
        - CONTRIBUTING.md
        - CHANGELOG.md
  - file_content_template: #rule identifier
      matching: # rule option
        .swiftlint.yml:
          template_url: "https://github.com/User/Templates/blob/stable/SwiftLint.stencil"
```


#### Shared Variables

A dictionary where you can define variables which can be used in strings anywhere amongst rule options. Say a variable named `project_name` was specified with the value `MyAmazingProject`, then all appearances of `<:project_name:>` in rule option strings will be replaced by `MyAmazingProject`. Here's what a config file using shared variables might look like:

```yaml
shared_variables:
  project_name: MyAmazingProject

rules:
  - file_existence:
      paths:
        - <:project_name:>.xcodeproj
        - <:project_name:>/Sources/AppDelegate.swift
```

## Contributing

Contributions are welcome. Please just **open an Issue** on GitHub to suggest a new rule or report an error with an existing one. Also feel free to **send a Pull Request** with your suggestion.

When sending a pull request please make sure to:
- **write tests for your changes** in order to make sure they don't break in the future
- follow the same syntax and semantic in your **commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/))
- add an entry into the `Unreleased` section of the `Changelog.md` file summarizing your change

Note that there is a framework target within the project to make testing easier. You can generate an Xcode project by running `swift package generate-xcodeproj`.

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
