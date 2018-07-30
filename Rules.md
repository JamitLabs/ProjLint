# Rules
This file contains a description and a list of options for every rule that ProjLint supports. The rules are sorted alphabetically by their name.

## Table of Rules

The following is a table of all available rules. Just click an option to get to it's available options.

Name | Identifier | Correctable? | Description
--- | --- | --- | ---
[File Existence](#file-existence) | `file_existence` | no | Specify files which must or must not exist.


## Rule Options

### File Existence

Option | Type | Required? | Description
--- | --- | ---
`existing_paths` | `[String]` | no | Files that must exist.
`non_existing_paths` | `[String]` | no | Files that must not exist.