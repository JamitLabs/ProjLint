<p align="center">
    <img src="https://raw.githubusercontent.com/JamitLabs/ProjLint/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/a3ce6767dee0a130">
        <img src="https://app.bitrise.io/app/a3ce6767dee0a130/status.svg?token=YIEEwn72h6tbGA6Zlr6bTQ&branch=stable"
             alt="Build Status">
    </a>
    <a href="https://codebeat.co/projects/github-com-jamitlabs-projlint-stable">
        <img src="https://codebeat.co/badges/721facf6-3505-48b1-ba3b-ae5cef9a3bf8"
             alt="Codebeat Badge">
    </a>
    <a href="https://github.com/JamitLabs/ProjLint/releases">
        <img src="https://img.shields.io/badge/Version-0.2.1-blue.svg"
             alt="Version: 0.2.1">
    </a>
    <img src="https://img.shields.io/badge/Swift-5.0-FFAC45.svg"
         alt="Swift: 5.0">
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

Project Linter to enforce your non-code best practices.

## Requirements

- Xcode 10.2+ and Swift 5.0+
- Xcode Command Line Tools (see [here](http://stackoverflow.com/a/9329325/3451975) for installation instructions)

## Installation

### Using [Homebrew](https://brew.sh):

To **install** ProjLint the first time run these commands:

```bash
brew tap JamitLabs/ProjLint https://github.com/JamitLabs/ProjLint.git
brew install projlint
```

To **update** to the latest version run:

```bash
brew upgrade projlint
```

### Using [Mint](https://github.com/yonaskolb/Mint):

To **install** the latest version of ProjLint simply run this command:

```bash
$ mint install JamitLabs/ProjLint
```

## Usage

ProjLint provides the following sub commands:
- **`lint`**: Lints the current directory and shows warnings and errors as console output.

**Shared Flags:**
- `--verbose`, `-v`: Prints out more detailed information about steps taken.

**Lint-only Flags:**
- `--xcode`, `-x`: Output are done in a format that is compatible with Xcode – for usage in Build Scripts.
- `--timeout`, `-t`: Seconds to wait for network requests until skipped.
- `--ignore-network-errors`, `-i`: Ignores network timeouts or missing network connection errors.
- `--strict`, `-s`: Exit with non-zero status on warnings, too. (Only for errors by default.)

NOTE: It is recommended to set the options `--timeout 2` and `--ignore-network-errors` if you plan to run `projlint lint` automatically on every build. Otherwise your build time might increase significantly on bad/missing internet connections.

### Configuration

To configure the checks ProjLint does for you, you need to have a YAML configuration file named `.projlint.yml` in the current directory. In there, you have the following sections:

- [`Default Options`](#default-options): Documented below, these options are applied to all rules unless they override them specifically.
- [`Rules with Options`](#rules-with-options): The list of rules to check & correct when the appropriate tasks are run with ability to customize them.
- [`Shared Variables`](#shared-variables): Define String variables to be replaced in rule options using structure `<:var_name:>`.

In addition to the `.projlint.yml` file, you can also place an additional `.projlint-local.yml` file with the same possibilities as in the normal config file. This allows you to share the same `.projlint.yml` file amongst multiple projects and keep them in sync while adding project-specific rules via the `-local` config file. Note that defaults options and shared variables with the same keys in the `-local` file will override those from the normal file.

#### Default Options

The following default options are available:

Option | Type | Required? | Description
--- | --- | --- | ---
`forced_violation_level` | `String` | no | One of `warning` or `error` – enforces the specified level on all violations.

All default options can be overridden by specifying a different value within the rule options. Here's an example:

```yaml
default_options:
  forced_violation_level: warning
```

#### Rules with Options

A list of all currently available rules and their options can be found in the [Rules.md](https://github.com/JamitLabs/ProjLint/blob/stable/Rules.md) file. The structure of how rules can be configured looks like the following:

```yaml
rules:
  - file_existence: # rule identifier
      forced_violation_level: warning # override default option
      paths: # rule option (note the additional indentation)
        - .swiftlint.yml
        - README.md
        - CONTRIBUTING.md
        - CHANGELOG.md
  - file_content_template: #rule identifier
      matching: # rule option
        .swiftlint.yml:
          template_url: "https://raw.githubusercontent.com/JamitLabs/ProjLintTemplates/master/iOS/SwiftLint.stencil"
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

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/ProjLint/blob/stable/CONTRIBUTING.md).

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
