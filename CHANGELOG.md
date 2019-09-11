# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- None.
### Changed
- None.
### Deprecated
- None.
### Removed
- None.
### Fixed
- None.
### Security
- None.

## [0.3.0] - 2019-09-11
### Added
- Make the rule `File Content Regex` print the offending lines.  
  Issue: [#31](https://github.com/JamitLabs/ProjLint/issues/31) | PR: [#32](https://github.com/JamitLabs/ProjLint/pull/32) | Author: [Andrés Cecilia Luque](https://github.com/acecilia)
- Added the `allowed_paths_regex` subrule under the file existance rule. Now it is possible to specify the allowed paths in a project by using multiple regexes.
  Issues: [#16](https://github.com/JamitLabs/ProjLint/issues/16), [#20](https://github.com/JamitLabs/ProjLint/issues/20) | PR: [#34](https://github.com/JamitLabs/ProjLint/pull/34) | Author: [Andrés Cecilia Luque](https://github.com/acecilia)
### Changed
- Replaced `lint_fail_level` configuration option with `strict` command line argument. Specify `--strict` or `-s` if you want the tool to fail on warnings.
### Fixed
- Updated project to use URLs instead of String paths.  
  Issue: [#35](https://github.com/JamitLabs/ProjLint/issues/35) | PR: [#33](https://github.com/JamitLabs/ProjLint/pull/33) | Author: [Andrés Cecilia Luque](https://github.com/acecilia)
