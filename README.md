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
$ mint install JamitLabs/ProjLint@stable projlint
```

To **update** to the newest version of TranslationManager when you have an old version already installed run:

```shell
$ mint update JamitLabs/ProjLint@stable projlint
```

## Usage

The TranslationManager provides the following sub commands:
- **`lint`**: Lints the current directory and shows warnings and errors as console output.
- **`correct`**: Corrects all correctable violations in the current directory.

### Configuration

To configure the checks ProjLint does for you, you need to have a YAML configuration file named `.projlint.yml` in the current directory. In there, you have two types of options:

- `Default Options`: Documented below, these options are applied to all rules unless they override them specifically.
- `Rules with Options`: The list of rules to check & correct when the appropriate tasks are run with ability to customize them.

#### Default Options

The following default options are available:

- `included_paths: [Regex]`: An array of Regexes to whitelist the directories & files to check.
- `excluded_paths: [Regex]`: An array of Regexes to blacklist the directories & files to check.
- `lint_fail_level: String`: One of `warning`, `error` or `never` – specifies when the `lint` command should fail. Defaults to `error`.

All default options can be overridden by specifying a different value within the rule options. Here's an example:

```yaml
default_options:
  excluded_paths:
    - "\.git/.*"
  lint_fail_level: warning
```

#### Rules with Options

A list of all currently available rules and their options can be found in the [Rules.md](#) file. The structure of how rules can be configures looks like the following:

```yaml
rules:
  - rule_name: # rule with options
      string_option_name: Hello World
      bool_option_name: true
      array_option_name:
        - A
        - B
        - C
  - another_rule # rule without options
```

## Contributing

Contributions are welcome. Please just **open an Issue** on GitHub to suggest a new rule or report an error with an existing one. Also feel free to **send a Pull Request** with your suggestion.

When sending a pull request please make sure to:
- **write tests for your changes** in order to make sure they don't break in the future
- follow the same syntax and semantic in your **commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/))
- add an entry into the`Next` section of the `Changelog.md` file summarizing your change

Note that there is a framework target within the project to make testing easier. You can generate an Xcode project by running `swift package generate-xcodeproj`.

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
