# Rules
This file contains a description and a list of options for every rule that ProjLint supports. The rules are sorted alphabetically by their name.

## Table of Rules

The following is a table of all available rules. Just click an option to get to it's available options.

Name | Identifier | Correctable? | Description
--- | --- | --- | ---
[File Content Regex](#file-content-regex) | `file_content_regex` | no | Specify files which must or must not include regex(es).
[File Content Template](#file-content-template) | `file_content_template` | no | Specify files which must or must not match a file template.
[File Existence](#file-existence) | `file_existence` | no | Specify files which must or must not exist.
[Xcode Build Phases](#xcode-build-phases) | `xcode_build_phases` | no | Specify build phases that need to exist and have same content.
[Xcode Project Navigator](#xcode-project-navigator) | `xcode_build_phases` | no | Specify how the project navigator should be structured.


## Rule Options

### File Content Regex

Option | Type | Required? | Description
--- | --- | --- | ---
`matching` | `[String: Regex]` | no | Paths with regex to check – fails if given regex doesn't match.
`matching_all` | `[String: [Regex]]` | no | Paths with regexes to check – fails if at least one regex doesn't match.
`matching_any` | `[String: [Regex]]` | no | Paths with regexes to check – fails if all regexes don't match.
`not_matching` | `[String: Regex]` | no | Paths with regex to check – fails if given regex matches.
`not_matching_all` | `[String: [Regex]]` | no | Paths with regexes – fails if all regexes match.
`not_matching_any` | `[String: [Regex]]` | no | Paths with regexes – fails if at least one regex matches.

<details>
<summary>Example</summary>

```yaml
rules:
  - file_content_regex:
      matching_all:
        Cartfile:
          - "#\\s*[^\\s]+" # Ensure dependencies are commented
          - HandySwift
          - SwiftyUserDefaults
          - SwiftyBeaver
      not_matching_all:
        Cartfile: # Moya already includes Alamofire, prevent redundancy
          - Alamofire
          - Moya
```

</details>

### File Content Template

Option | Type | Required? | Description
--- | --- | --- | ---
`matching` | `[String: ["template_path/template_url": String, "parameters": [String: Any]]` | no | Paths with template & parameters to check – fails if given template with parameters applied doesn't match the file contents.

<details>
<summary>Example</summary>

```yaml
rules:
  - file_content_template:
      matching:
        .swiftlint.yml:
          template_url: "https://raw.githubusercontent.com/JamitLabs/ProjLintTemplates/master/iOS/SwiftLint.stencil"
          parameters:
            additionalRules:
              - attributes
              - empty_count
              - sorted_imports
            lineLength: 160
```

Where the file `SwiftLint.stencil` could be a [Stencil](https://github.com/stencilproject/Stencil) template looking like this:

```stencil
# Basic Configuration
opt_in_rules:
{% for rule in additionalRules %}
- {{ rule }}
{% endfor %}

disabled_rules:
- type_name

included:
- Sources
- Tests

# Rule Configurations
identifier_name:
  excluded:
    - id

line_length: {{ lineLength }}
```

Note that a `template_path` should be specified for local paths and a `template_url` should be specified if your file needs to be downloaded from the web.

</details>

### File Existence

Option | Type | Required? | Description
--- | --- | --- | ---
`existing_paths` | `[String]` | no | Files that must exist.
`non_existing_paths` | `[String]` | no | Files that must not exist.
`allowed_paths_regex` | `[String]` | no | A list of regexes matching only allowed paths: files with a path that do not match the regex will trigger a violation.

<details>
<summary>Example</summary>

```yaml
rules:
  - file_existence:
      existing_paths:
        - .gitignore
        - README.md
        - Cartfile
        - Cartfile.private
        - Cartfile.resolved
      non_existing_paths:
        - Podfile
        - Podfile.lock
      allowed_paths_regex:
        - (Sources|Tests)/.+\.swift # Sources
        - (Resources|Formula)/.+ # Other necessary resources
        - \.(build|sourcery|git|templates)/.+ # Necessary files under hidden directories
        - ProjLint\.xcodeproj/.+ # Xcode project
        - '[^/]+' # Root files (needs quotation because the regex contains reserved yaml characters)
```

</details>

### Xcode Build Phases

Option | Type | Required? | Description
--- | --- | --- | ---
`project_path` | `String` | yes | The (relative) path to the `.xcodeproj` file.
`target_name` | `String` | yes | The name of the targets whose build phases to be checked.
`run_scripts` | `[String: String]` | yes | The build scripts to be checked – the key is the name, the value the script contents.

<details>
<summary>Example</summary>

```yaml
rules:
  - xcode_build_phases:
      project_path: AmazingApp.xcodeproj
      target_name: AmazingApp
      run_scripts:
        SwiftLint: |
          if which swiftlint > /dev/null; then
              swiftlint
          else
              echo "warning: SwiftLint not installed, download it from https://github.com/realm/SwiftLint"
          fi
```

</details>

### Xcode Project Navigator

Option | Type | Required? | Description
--- | --- | --- | ---
`project_path` | `String` | yes | The (relative) path to the `.xcodeproj` file.
`sorted` | `[String]` | no | The group paths to check recursively for sorted entries (aware of inner_group_order).
`inner_group_order` | `[String OR [String]]` | yes | The order of types within groups. Available types: `interfaces`, `code_files`, `assets`, `strings`, `folders`, `plists`, `entitlements`, `others`.
`structure` | `[String: Any]` | yes | The structure of files and folders to check for their existence.

<details>
<summary>Example</summary>

```yaml
rules:
  - xcode_project_navigator:
      project_path: AmazingApp.xcodeproj
      sorted:
        - App/Sources
        - App/Generated
        - Tests/Sources
        - UITests/Sources/
      inner_group_order:
        - assets
        - entitlements
        - plists
        - strings
        - others
        - [code_files, interfaces]
        - folders
      structure:
        - App:
            - Sources:
                - AppDelegate.swift
                - Globals:
                    - Extensions
            - Resources:
                - Colors.xcassets
                - Images.xcassets
                - Localizable.strings
                - Fonts
            - SupportingFiles:
                - LaunchScreen.storyboard
                - Info.plist
        - Tests:
            - Sources
            - Resources
            - SupportingFiles:
                - Info.plist
        - UITests:
            - Sources
            - Resources
            - SupportingFiles:
                - Info.plist
        - Extensions
        - Frameworks
        - Products
```

</details>
