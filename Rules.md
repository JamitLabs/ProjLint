# Rules
This file contains a description and a list of options for every rule that ProjLint supports. The rules are sorted alphabetically by their name.

## Table of Rules

The following is a table of all available rules. Just click an option to get to it's available options.

Name | Identifier | Correctable? | Description
--- | --- | --- | ---
[File Content Regex](#file-content-regex) | `file_content_regex` | no | Specify files which must or must not include regex(es).
[File Existence](#file-existence) | `file_existence` | no | Specify files which must or must not exist.


## Rule Options

### File Content Regex

Option | Type | Required? | Description
--- | --- | --- | ---
`matching_all` | `[String: [Regex]]` | no | Paths with regexes to check – fails if at least one regex doesn't match.
`matching_any` | `[String: [Regex]]` | no | Paths with regexes to check – fails if all regexes don't match.
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