# Rules
This file contains a description and a list of options for every rule that ProjLint supports. The rules are sorted alphabetically by their name.

## Table of Rules

The following is a table of all available rules. Just click an option to get to it's available options.

Name | Identifier | Correctable? | Description
--- | --- | --- | ---
[File Content Regex](#file-content-regex) | `file_content_regex` | no | Specify files which must or must not include regex(es).
[File Content Template](#file-content-template) | `file_content_template` | no | Specify files which must or must not match a file template.
[File Existence](#file-existence) | `file_existence` | no | Specify files which must or must not exist.


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
          template_url: "https://github.com/User/Templates/blob/stable/SwiftLint.stencil"
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
```

</details>