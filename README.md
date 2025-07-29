# Pre-Commit-GoLang [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A set of git pre-commit hooks for Golang with support for multi-module monorepos, the ability to pass arguments and environment variables to all hooks, and the ability to invoke custom go tools.

Requires the [Pre-Commit.com](https://pre-commit.com) Hook Management Framework.

---------------
## Installation

You can copy/paste the following snippet into your `.pre-commit-config.yaml` file.

**NOTE** A more fleshed-out version can be found in [`sample-config.yaml`](https://github.com/TekWizely/pre-commit-golang/blob/master/sample-config.yaml)

```yaml
    # ==========================================================================
    # Golang Pre-Commit Hooks | https://github.com/tekwizely/pre-commit-golang
    #
    # !! ALL Hooks enabled by default - Comment out hooks you are not using
    #
    # Visit the project home page to learn more about the available Hooks,
    # including useful arguments you might want to pass into them.
    #
    # NOTE: When passing options to hooks, if your options contain a reference
    #       to an existing file, then you will need to use a trailing '--'
    #       argument to separate the hook options from the modified-file list
    #       that Pre-Commit passes into the hook.
    #       For repo-based hooks, '--' is not needed.
    #
    # NOTE: You can pass environment variables to hooks using args with the
    #       following format:
    #
    #           --hook:env:NAME=VALUE
    #
    # Consider adding aliases to longer-named hooks for easier CLI usage.
    # ==========================================================================
-   repo: https://github.com/tekwizely/pre-commit-golang
    rev: master
    hooks:
    #
    # Go Build
    #
    -   id: go-build-mod
    -   id: go-build-pkg
    -   id: go-build-repo-mod
    -   id: go-build-repo-pkg
    #
    # Go Mod Tidy
    #
    -   id: go-mod-tidy
    -   id: go-mod-tidy-repo
    #
    # Go Test
    #
    -   id: go-test-mod
    -   id: go-test-pkg
    -   id: go-test-repo-mod
    -   id: go-test-repo-pkg
    #
    # Go Vet
    #
    -   id: go-vet
    -   id: go-vet-mod
    -   id: go-vet-pkg
    -   id: go-vet-repo-mod
    -   id: go-vet-repo-pkg
    #
    # Revive
    #
    -   id: go-revive
    -   id: go-revive-mod
    -   id: go-revive-repo-mod
    #
    # GoSec
    #
    -   id: go-sec-mod
    -   id: go-sec-pkg
    -   id: go-sec-repo-mod
    -   id: go-sec-repo-pkg
    #
    # StaticCheck
    #
    -   id: go-staticcheck-mod
    -   id: go-staticcheck-pkg
    -   id: go-staticcheck-repo-mod
    -   id: go-staticcheck-repo-pkg
    #
    # StructSlop
    #
    -   id: go-structslop-mod
    -   id: go-structslop-pkg
    -   id: go-structslop-repo-mod
    -   id: go-structslop-repo-pkg
    #
    # Formatters
    #
    -   id: go-fmt
    -   id: go-fmt-repo
    -   id: go-fumpt        # replaces go-fmt
    -   id: go-fumpt-repo   # replaces go-fmt-repo
    -   id: go-imports      # replaces go-fmt
    -   id: go-imports-repo # replaces go-fmt-repo
    -   id: go-returns      # replaces go-imports & go-fmt
    -   id: go-returns-repo # replaces go-imports-repo & go-fmt-repo
    #
    # Style Checkers
    #
    -   id: go-lint
    -   id: go-critic
    #
    # GolangCI-Lint
    # - Fast Multi-Linter
    # - Can be configured to replace MOST other hooks
    # - Supports repo config file for configuration
    # - https://github.com/golangci/golangci-lint
    #
    -   id: golangci-lint
    -   id: golangci-lint-mod
    -   id: golangci-lint-pkg
    -   id: golangci-lint-repo-mod
    -   id: golangci-lint-repo-pkg
    #
    # Invoking Custom Go Tools
    # - Configured *entirely* through the `args` attribute, ie:
    #   args: [ go, test, ./... ]
    # - Use arg `--hook:error-on-output` to indicate that any output from the tool
    #   should be treated as an error.
    # - Use the `name` attribute to provide better messaging when the hook runs
    # - Use the `alias` attribute to be able to invoke your hook via `pre-commit run`
    #
    -   id: my-cmd
    -   id: my-cmd-mod
    -   id: my-cmd-pkg
    -   id: my-cmd-repo
    -   id: my-cmd-repo-mod
    -   id: my-cmd-repo-pkg
```

-----------
## Overview

### Hook Targets

#### File-Based Hooks
Some hooks run against matching staged files individually.

##### Module-Based Hooks
Some hooks work on a per-module basis.  The hooks run against module root folders containing one or more matching staged files.

_Module Root Folder:_ A folder containing a `go.mod` file.  Discovered by walking up the folder path from the staged file.

###### Module Mode
Module-based hooks enable module mode (`GO111MODULE=on`) before invoking their respective tools.

##### Package-Based Hooks
Some hooks work on a per-package basis.  The hooks run against folders containing one or more staged files.

_Package Folder:_ A folder containing one or more `.go` files.

###### Package Mode
Package-based hooks disable module mode (`GO111MODULE=off`) before invoking their respective tools.

##### Repo-Based Hooks
Some hooks run against the entire repo.  The hooks only run once (if any matching files are staged), and are NOT provided the list of staged files,

-----------------
### Hook Suffixes
Hooks have suffixes in their name that indicate their targets:

| Suffix      | Target       | Description                                       |
|-------------|--------------|---------------------------------------------------|
| \<none>     | Files        | Targets staged files directly                     |
| `-mod`      | Module       | Targets module root folders of staged `.go` files |
| `-pkg`      | Package      | Targets folders containing staged `.go` files     |
| `-repo`     | Repo Root    | Targets the repo root folder                      |
| `-repo-mod` | All Modules  | Targets all module root folders in the repo       |
| `-repo-pkg` | All Packages | Targets all package folders in the repo           |

-----------------------------
### Multiple Hook Invocations
Due to OS command-line-length limits, Pre-Commit can invoke a hook multiple times if a large number of files are staged.

For file and repo-based hooks, this isn't an issue, but for module and package-based hooks, there is a potential for the hook to run against the same module or package multiple times, duplicating any errors or warnings.

-------------------------
### Invoking Custom Tools
While this project includes builtin hooks for many popular go tools, it's not possible to include builtin hooks for every tool that users might want to use.

To help accommodate those users, this project includes the ability to invoke custom go tools.

See the [my-cmd](#my-cmd) hooks for more information.

--------------------------
### Useful Hook Parameters
```
-   id: hook-id
    args: [arg1, arg2, ..., '--'] # Pass options ('--' is optional)
    always_run: true              # Run even if no matching files staged
    alias: hook-alias             # Create an alias
    verbose: true                 # Display output, even if no errors
```

#### Passing Options To Hooks
You can pass options into individual hooks to customize tool behavior.

If your options contain a reference to an existing file, then you
will need to use a trailing `'--'` argument to separate the hook options from
the modified-file list that Pre-Commit passes into the hook.

**NOTE:** For repo-based hooks, `'--'` is not needed.

See each hook's description below for some popular options that you might want to use.

Additionally, you can view each tool's individual home page or help settings to learn about all the available options.

#### Passing Environment Variables To Hooks
You can pass environment variables to hooks to customize tool behavior.

**NOTE:** The Pre-Commit framework does not directly support the ability to pass environment variables to hooks.

This feature is enabled via support for a specially-formatted argument:

* `--hook:env:NAME=VALUE`

The hook script will detect this argument and set the variable `NAME` to the value `VALUE` before invoking the configured tool.

You can pass multiple  `--hook:env:` arguments.

The arguments can appear anywhere in the `args:` list.

#### Passing Ignore Patterns To Hooks

You can pass arguments to hooks to specify files / directories to ignore.

##### Ignoring Directories

To specify a directory to ignore, use:

* `--hook:ignore-dir=PATTERN`

**Pattern Syntax**

Here's a table with examples of how the directory ignore patterns work:

| <sub>(see legend below)</sub> | `/foo` | `/foo/bar` | `/foo/*/bar` | `bar` | `bing/bar` | `bing/*/bar` | `foo/*/bang/*/bar` |
|:------------------------------|:------:|:----------:|:------------:|:-----:|:----------:|:------------:|:------------------:|
| `file`                        |        |            |              |       |            |              |                    |
| `foo/file`                    |   ✔    |            |              |       |            |              |                    |
| `foo/bar/file`                |   ✔    |     ✔      |              |   ✔   |            |              |                    |
| `foo/bing/bar/file`           |   ✔    |            |      ✔       |   ✔   |     ✔      |              |                    |
| `foo/bing/bang/bar/file`      |   ✔    |            |      ✔       |   ✔   |            |      ✔       |                    |
| `foo/bing/bang/baz/bar/file`  |   ✔    |            |      ✔       |   ✔   |            |      ✔       |         ✔          |
| `bar/file`                    |        |            |              |   ✔   |            |              |                    |
| `bing/bar/file`               |        |            |              |   ✔   |     ✔      |              |                    |
| `bing/bang/bar/file`          |        |            |              |   ✔   |            |      ✔       |                    |

<sub>rows = filenames. columns = ignore patterns. ✔ = directory ignored (matched).</sub>

NOTES:
* Only the directory portion of the filename is considered for matching
  * File `foo/bar/file` would attempt to match patterns against the directory `foo/bar`
* Patterns with leading slash (`/`) indicate that the pattern is _anchored_ and must match the **beginning** of the directory path
  * Pattern `/bar` would match filenames `bar/file` and `bar/bang/file`, but **not** `foo/bar/file`
* Patterns without leading slash (`/`) indicate that the pattern is _floating_ and can match **anywhere** in the directory path
  * Pattern `bar` would match **all** filenames `bar/file`, `bar/bang/file` and `foo/bar/file`
* Trailing slashes (`foo/`) are not supported and are ignored
* Explicit Leading and trailing wildcards (`*/foo`, `foo/*`, `*/foo/*`) are not supported
* Recursive directory patterns (`**`) are not supported

##### Ignoring Files

To specify files to ignore, use:

* `--hook:ignore-file=PATTERN`

**Pattern Syntax**

Here's a table with examples of how the file ignore patterns work:

| <sub>(see legend below)</sub> | `file1.txt` | `file?.txt` | `file2.*` | `*.md` | `bar/*.md` | `/bar/*.txt` |
|:------------------------------|:-----------:|:-----------:|:---------:|:------:|:----------:|:------------:|
| `file1.txt`                   |      ✔      |      ✔      |           |        |            |              |
| `file2.txt`                   |             |      ✔      |     ✔     |        |            |              |
| `file3.md`                    |             |             |           |   ✔    |            |              |
| `foo/file1.txt`               |      ✔      |      ✔      |           |        |            |              |
| `bar/file1.txt`               |      ✔      |      ✔      |           |        |            |      ✔       |
| `bar/file2.md`                |             |             |     ✔     |   ✔    |     ✔      |              |
| `foo/bar/file4.txt`           |             |      ✔      |           |        |            |              |
| `foo/bar/file5.md`            |             |             |           |   ✔    |     ✔      |              |

<sub>rows = filenames. columns = ignore patterns. ✔ = file ignored (matched).</sub>

NOTES:
* Patterns with no slashes (`/`) are only matched against the filename portion of the file path
    * Pattern `file.txt` would match filenames `file.txt`, `foo/file.txt`, and `bar/file.txt`
* Patterns with leading slash (`/`) indicate that the pattern is _anchored_ and must match the **full** file path
    * Pattern `/bar/file` would match filename `bar/file`, but **not** `foo/bar/file`
* Patterns without leading slash (`/`) indicate that the pattern is _trailing_ and just needs to match the **end** of the file path
    * Pattern `bar/file` would match filenames `bar/file` and `foo/bar/file`
* Explicit Leading  (`*/foo/file`) are not supported
* Recursive directory patterns (`**`) are not supported


##### Ignore By Pattern

If the directory and file-based convenience options are not enough, you can specify a more complicated (bash-specific) pattern.

To specify these types of patterns to ignore, use:

* `--hook:ignore-pattern=PATTERN`

**Pattern Syntax**

Here's a table with examples of how the general ignore patterns work:

| <sub>(see legend below)</sub> | `file` | `foo/bar/*` | `foo/*/bar/*` | `*/file` | `*/bar/file` | `*/bar/*` | `*/bing/*/bar/*` | `*/b?ng/*/file` |
|:------------------------------|:------:|:-----------:|:-------------:|:--------:|:------------:|:---------:|:----------------:|:---------------:|
| `file`                        |   ✔    |             |               |          |              |           |                  |                 |
| `foo/file`                    |        |             |               |    ✔     |              |           |                  |                 |
| `foo/bar/file`                |        |      ✔      |               |    ✔     |      ✔       |     ✔     |                  |                 |
| `foo/bing/bar/file`           |        |             |       ✔       |    ✔     |      ✔       |     ✔     |                  |        ✔        |
| `foo/bang/bar/file`           |        |             |       ✔       |    ✔     |      ✔       |     ✔     |                  |        ✔        |
| `foo/bing/bang/bar/file`      |        |             |       ✔       |    ✔     |      ✔       |     ✔     |        ✔         |        ✔        |
| `foo/bing/bang/baz/bar/file`  |        |             |       ✔       |    ✔     |      ✔       |     ✔     |        ✔         |        ✔        |
| `bar/file`                    |        |             |               |    ✔     |              |           |                  |                 |
| `bing/bar/file`               |        |             |               |    ✔     |      ✔       |     ✔     |                  |                 |
| `bing/bang/bar/file`          |        |             |               |    ✔     |      ✔       |     ✔     |                  |        ✔        |
| `.file`                       |        |             |               |          |              |           |                  |                 |
| `.bar/file`                   |        |             |               |    ✔     |              |           |                  |                 |
| `foo/.bang/bar/file`          |        |             |       ✔       |    ✔     |      ✔       |     ✔     |                  |                 |

<sub>rows = filenames. columns = ignore patterns. ✔ = file ignored (matched).</sub>

NOTES:
* Patterns are matched against the **full** (relative) file path
* Patterns are Bash-specific (although _possibly_ POSIX compliant) and are **not** regular expressions (regex)
* See the Official Bash documentation for [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)
* Patterns based on `extglob` setting/syntax are **not** supported

#### Always Run
By default, hooks ONLY run when matching file types (usually `*.go`) are staged.

When configured to `"always_run"`, a hook is executed as if EVERY matching file were staged.

#### Aliases / Names

pre-commit supports the ability to assign both an `alias` and a `name` to a configured hook:

| config | description                                                                                             |
|--------|---------------------------------------------------------------------------------------------------------|
| alias  | (optional) allows the hook to be referenced using an additional id when using `pre-commit run <hookid>` |
| name   | (optional) override the name of the hook - shown during hook execution                                  |

These are beneficial for a couple of reasons:

* Creating short names for long-named hooks for easier CLI usage:
```
# ...
      hooks:
        -   id: go-build-repo-mod
            alias: build
```
_usage_
```
$ pre-commit run build
```

* Having variations of a given hook with different configurations:
```
# ...
    hooks:
      -   id: go-fmt

          # Add a second go-fmt hook with -w enabled
          # Configure so it only runs when manually invoked
      -   id: go-fmt
          args: [ -w ]
          alias: go-fmtw-alias
          name: go-fmtw-name
          stages: [manual]
```
 **NOTE:** When creating variations, take note that the `alias` is used to execute the hook, but the the `name` is used in the hook report.

 _usage: alias vs name_
```
 $ pre-commit run --hook-stage manual go-fmtw-alias

 go-fmtw-name................................Passed
```

#### Verbose Hook Output
When the `"verbose"` flag is enabled, all output generated by the hook will be displayed, even if there were no errors.

This can be useful, for example, for hooks that display warnings, but don't generate error codes for them.

--------
## Hooks

 - Build Tools
   - [go-build](#go-build)
   - [go-mod-tidy](#go-mod-tidy)
 - Correctness Checkers
   - [go-test](#go-test)
   - [go-vet](#go-vet)
   - [go-sec](#go-sec)
   - [go-staticcheck](#go-staticcheck)
   - [go-structslop](#go-structslop)
 - Formatters
   - [go-fmt](#go-fmt)
   - [go-fumpt](#go-fumpt)
   - [go-imports](#go-imports)
   - [go-returns](#go-returns)
 - Style Checkers
   - [go-lint](#go-lint)
   - [go-critic](#go-critic)
   - [go-revive](#go-revive)
 - GolangCI-Lint
   - [golangci-lint](#golangci-lint)
 - Invoking Custom Tools
   - [my-cmd](#my-cmd)

------------
### go-build
Compiles packages, along with their dependencies, but does not install the results.

| Hook ID             | Description
|---------------------|------------
| `go-build-mod`      | Run `'cd $(mod_root $FILE); go build -o /dev/null [$ARGS] ./...'` for each staged .go file
| `go-build-pkg`      | Run `'go build -o /dev/null [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-build-repo-mod` | Run `'cd $(mod_root); go build -o /dev/null [$ARGS] ./...'` for each module in the repo
| `go-build-repo-pkg` | Run `'go build -o /dev/null [$ARGS] ./...'` in repo root folder

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Help
 - https://golang.org/cmd/go/#hdr-Compile_packages_and_dependencies
 - `go help build`

---------------
### go-mod-tidy
Makes sure `go.mod` matches the source code in the module.

| Hook ID            | Description
|--------------------|------------
| `go-mod-tidy`      | Run `'cd $(mod_root $FILE); go mod tidy [$ARGS] ./...'` for each staged .go file
| `go-mod-tidy-repo` | Run `'cd $(mod_root); go mod tidy [$ARGS] ./...'` for each module in the repo

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Help
 - https://golang.org/ref/mod#go-mod-tidy
 - `go mod help tidy`

-----------
### go-test
Automates testing, printing a summary of test results.

| Hook ID            | Description
|--------------------|------------
| `go-test-mod`      | Run `'cd $(mod_root $FILE); go test [$ARGS] ./...'` for each staged .go file
| `go-test-pkg`      | Run `'go test [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-test-repo-mod` | Run `'cd $(mod_root); go test [$ARGS] ./...'` for each module in the repo
| `go-test-repo-pkg` | Run `'go test [$ARGS] ./...'` in repo root folder

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Help
 - https://golang.org/cmd/go/#hdr-Test_packages
 - `go help test`

----------
### go-sec
Inspects source code for security problems by scanning the Go AST.

| Hook ID           | Description
|-------------------|------------
| `go-sec-mod`      | Run `'cd $(mod_root $FILE); gosec [$ARGS] ./...'` for each staged .go file
| `go-sec-pkg`      | Run `'gosec [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-sec-repo-mod` | Run `'cd $(mod_root); gosec [$ARGS] ./...'` for each module in the repo
| `go-sec-repo-pkg` | Run `'gosec [$ARGS] ./...'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install github.com/securego/gosec/v2/cmd/gosec
```

##### Help
 - https://github.com/securego/gosec#usage
 - `gosec (no args)`

------------------
### go-staticcheck
A state of the art linter for the Go programming language. Using static analysis, it finds bugs and performance issues, offers simplifications, and enforces style rules.

| Hook ID                   | Description
|---------------------------|------------
| `go-staticcheck-mod`      | Run `'cd $(mod_root $FILE); staticcheck [$ARGS] ./...'` for each staged .go file
| `go-staticcheck-pkg`      | Run `'staticcheck [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-staticcheck-repo-mod` | Run `'cd $(mod_root); staticcheck [$ARGS] ./...'` for each module in the repo
| `go-staticcheck-repo-pkg` | Run `'staticcheck [$ARGS] ./...'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install honnef.co/go/tools/cmd/staticcheck
```

##### Help
 - https://staticcheck.io/
 - `staticcheck -h`

-----------------
### go-structslop
Recommends struct field rearrangements to provide for maximum space/allocation efficiency.

 - Can modify files (see `-apply`)

| Hook ID                  | Description
|--------------------------|------------
| `go-structslop-mod`      | Run `'cd $(mod_root $FILE); structslop [$ARGS] ./...'` for each staged .go file
| `go-structslop-pkg`      | Run `'structslop [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-structslop-repo-mod` | Run `'cd $(mod_root); structslop [$ARGS] ./...'` for each module in the repo
| `go-structslop-repo-pkg` | Run `'structslop [$ARGS] ./...'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install github.com/orijtech/structslop/cmd/structslop
```

##### Useful Args
```
-apply : apply suggested fixes
```

##### Help
 - https://github.com/orijtech/structslop#usage
 - `structslop -h`

----------
### go-vet
Examines Go source code and reports suspicious constructs, such as
Printf calls whose arguments do not align with the format string. Vet uses
heuristics that do not guarantee all reports are genuine problems, but it
can find errors not caught by the compilers.

| Hook ID           | Description
|-------------------|------------
| `go-vet`          | Run `'go vet [$ARGS] $FILE'` for each staged .go file
| `go-vet-mod`      | Run `'cd $(mod_root $FILE); go vet [$ARGS] ./...'` for each staged .go file
| `go-vet-pkg`      | Run `'go vet [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-vet-repo-mod` | Run `'cd $(mod_root); go vet [$ARGS] ./...'` for each module in the repo
| `go-vet-repo-pkg` | Run `'go vet [$ARGS] ./...'` in repo root folder

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Help
 - https://golang.org/cmd/go/#hdr-Report_likely_mistakes_in_packages
 - `go doc cmd/vet`

----------
### go-fmt
Formats Go programs. It uses tabs for indentation and blanks for alignment. Alignment assumes that an editor is using a fixed-width font.

 - Can modify files (see `-w`)

| Hook ID       | Description
|---------------|------------
| `go-fmt`      | Run `'gofmt -l -d [$ARGS] $FILE'` for each staged .go file
| `go-fmt-repo` | Run `'gofmt -l -d [$ARGS] .'` in repo root folder

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Useful Args
```
-d=false : Hide diffs
-s       : Try to simplify code
-w       : Update source file directly
```

##### Help
 - https://godoc.org/github.com/golang/go/src/cmd/gofmt
 - `gofmt -h`

------------
### go-fumpt
Enforce a stricter format than `gofmt`, while being backwards compatible.

 - Replaces `go-fmt`
 - Can modify files (see `-w`)

| Hook ID         | Description
|-----------------|------------
| `go-fumpt`      | Run `'gofumpt -l -d [$ARGS] $FILE'` for each staged .go file
| `go-fumpt-repo` | Run `'gofumpt -l -d [$ARGS] .'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install mvdan.cc/gofumpt
```

##### Useful Args
```
-d=false : Hide diffs
-extra   : Enable extra rules which should be vetted by a human
-s       : Try to simplify code
-w       : Update source file directly
```

##### Help
 - https://pkg.go.dev/mvdan.cc/gofumpt
 - `gofumpt -h`

--------------
### go-imports
Updates your Go import lines, adding missing ones and removing unreferenced ones.

 - Replaces `go-fmt`
 - Can modify files (see `-w`)

| Hook ID           | Description
|-------------------|------------
| `go-imports`      | Run `'goimports -l -d [$ARGS] $FILE'` for each staged .go file
| `go-imports-repo` | Run `'goimports -l -d [$ARGS] .'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install golang.org/x/tools/cmd/goimports
```

##### Useful Args
```
-d=false        : Hide diffs
-format-only    : Do not fix imports, act ONLY as go-fmt
-local prefixes : Add imports matching prefix AFTER 3rd party packages
                  (prefixes = comma-separated list)
-v              : Verbose logging
-w              : Update source file directly
```

##### Help
 - https://godoc.org/golang.org/x/tools/cmd/goimports
 - `goimports -h`

--------------
### go-returns
Implements a Go pretty-printer (like `go-fmt`) that also adds zero-value return values as necessary to incomplete return statements.

 - Replaces `go-fmt` and `go-imports`
 - Can modify files (see `-w`)

| Hook ID           | Description
|-------------------|------------
| `go-returns`      | Run `'goreturns -l -d [$ARGS] $FILE'` for each staged .go file
| `go-returns-repo` | Run `'goreturns -l -d [$ARGS] .'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install github.com/sqs/goreturns
```

##### Useful Args
```
-b              : Remove bare returns
-d=false        : Hide diffs
-i=false        : Disable go-imports
-local prefixes : Add imports matching prefix AFTER 3rd party packages
                  (prefixes = comma-separated list)
-p              : Print non-fatal type-checking errors to STDERR
-s              : Try to simplify code
-w              : Update source file directly
```

##### Help
 - https://godoc.org/github.com/sqs/goreturns
 - `goreturns -h`

-----------
### go-lint
A linter for Go source code, meant to carry out the stylistic conventions put forth in [Effective Go](https://golang.org/doc/effective_go.html) and [CodeReviewComments](https://golang.org/wiki/CodeReviewComments).

| Hook ID   | Description
|-----------|------------
| `go-lint` | Run `'golint -set_exit_status [$ARGS] $FILE'` for each staged .go file

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install golang.org/x/lint/golint
```

##### Help
 - https://godoc.org/golang.org/x/lint
 - `golint -h`
 - https://golang.org/doc/effective_go.html
 - https://golang.org/wiki/CodeReviewComments

-------------
### go-revive
\~6x faster, stricter, configurable, extensible, and beautiful drop-in replacement for golint.

| Hook ID   | Description
|-----------|------------
| `go-revive`          | Run `'revive [$ARGS] $FILE'` for each staged .go file
| `go-revive-mod`      | Run `'cd $(mod_root $FILE); revive [$ARGS] ./...'` for each staged .go file
| `go-revive-repo-mod` | Run `'cd $(mod_root); revive [$ARGS] ./...'` for each module in the repo

##### Support for Repository-Level Config
As of time of writing, revive only auto-checks for configs in `${HOME}/revive.toml`, and doesn't check the local folder (ie. `${REPO_ROOT}/revive.toml`).

To make revive more useful, these hooks add built-in support for a repository-level config file.

###### Auto-Configured
These hooks are configured to auto-add `-config=revive.toml` when the file is present in the repository root.

###### Triggerred When Modified
These hooks are configured to run when the repo-level `revive.toml` file is modified (and staged).

**NOTE:** Although configured to run, the file-based `go-revive` hook will, by default, effectively _do nothing_ if there are no staged `.go` files to run against.

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install github.com/mgechev/revive
```

##### Useful Args
```
-config [PATH]     : Path to config file (TOML)
-exclude [PATTERN] : Pattern for files/directories/packages to be excluded from linting
-formatter [NAME]  : formatter to be used for the output
```

##### Displaying Warnings
By default, `revive` doesn't generate errors on warnings, so warning messages may not be displayed if there are no accompanying error messages.

You can use the `"verbose: true"` hook configuration to always show hook output.

##### Help
 - https://github.com/mgechev/revive#usage
 - `revive -h`

-------------
### go-critic
The most opinionated Go source code linter for code audit.

| Hook ID     | Description
|-------------|------------
| `go-critic` | Run `'gocritic check [$ARGS] $FILE'` for each staged .go file

##### Install
   https://github.com/go-critic/go-critic#installation

##### Useful Args
```
-enableAll        : Enable ALL checkers
-enable checkers  : comma-separated list of checkers to be enabled
                    (can include #tags)
-disable checkers : comma-separated list of checkers to be disabled
                    (can include #tags)
```
**Tags**
 - `#diagnostic`
 - `#style`
 - `#opinionated`
 - `#performance`
 - `#experimental`

#### Help
 - https://go-critic.github.io/overview
 - `gocritic check -help`

-----------------
### golangci-lint
A FAST linter aggregator, with colored output, fewer false-positives, and support for yaml/toml configuration.

 - Manages multiple linters
 - Can replace many/most other hooks
 - Can report only new issues (see `--new`)
 - Can modify files (see `--fix`)

| Hook ID                  | Description
|--------------------------|------------
| `golangci-lint`          | Run `'golangci-lint run [$ARGS] $FILE'` for each staged .go file
| `golangci-lint-mod`      | Run `'cd $(mod_root $FILE); golangci-lint run [$ARGS] ./...'` for each staged .go file
| `golangci-lint-pkg`      | Run `'golangci-lint run [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `golangci-lint-repo-mod` | Run `'cd $(mod_root); golangci-lint run [$ARGS] ./...'` for each module in the repo
| `golangci-lint-repo-pkg` | Run `'golangci-lint run [$ARGS] ./...'` in repo root folder

##### Install (via [bingo](https://github.com/TekWizely/bingo))
```
bingo install github.com/golangci/golangci-lint/cmd/golangci-lint
```
##### Useful Args
```
   --config PATH     : Specify config file
   --disable linters : Disable specific linter(s)
   --enable-all      : Enable ALL linters
   --enable linters  : Enable specific linter(s)
   --fast            : Run only fast linters (from enabled linters sets)
   --fix             : Fix found issues (if supported by linter)
   --new             : Show only new issues (see help for further details)
   --no-config       : don't read config file
   --presets presets : Enable presets of linters
```
**Presets**
 - `bugs`
 - `complexity`
 - `format`
 - `performance`
 - `style`
 - `unused`

##### Help
 - https://github.com/golangci/golangci-lint#quick-start
 - `golangci-lint run -h`

##### Config File Help:
 - https://github.com/golangci/golangci-lint#config-file
 - `golangci-lint config -h`

----------
### my-cmd

Using the `my-cmd-*` hooks, you can invoke custom go tools in various contexts.

 | Hook ID           | Description
 |-------------------|------------
 | `my-cmd`          | Run `'$ARGS[0] [$ARGS[1:]] $FILE'` for each staged .go file
 | `my-cmd-mod`      | Run `'cd $(mod_root $FILE); GO111MODULE=on $ARGS[0] [$ARGS[1:]]'` for each staged .go file
 | `my-cmd-pkg`      | Run `'GO111MODULE=off $ARGS[0] [$ARGS[1:]] ./$(dirname $FILE)'` for each staged .go file
 | `my-cmd-repo`     | Run `'$ARGS[0] [$ARGS[1:]]'` in the repo root folder
 | `my-cmd-repo-mod` | Run `'cd $(mod_root); GO111MODULE=on $ARGS[0] [$ARGS[1:]]'` for each module in the repo
 | `my-cmd-repo-pkg` | Run `'GO111MODULE=off $ARGS[0] [$ARGS[1:]]` in repo root folder

#### Configuring the hooks

The my-cmd hooks are configured **entirely** through the pre-commit `args` attribute, including specifying which tool to run (ie `$ARGS[0]` above).

This includes the need to manually add the `./...` target for module-based tools that require it.

#### Examples

Here's an example of what it would look like to use the my-cmd hooks to invoke `go test` if it wasn't already included:

_.pre-commit-config.yaml_
```
# ...
      hooks:
            # Run 'cd $(mod_root $FILE); go test ./...' for each staged .go file
        -   id: my-cmd-mod
            name: go-test-mod
            alias: go-test-mod
            args: [ go, test, ./... ]
```

##### Names &amp; Aliases

It is recommended that you use both `name` and `alias` attributes when defining my-cmd hooks.

The name will provide better messaging when the hook runs.

The alias will enable you to invoke the hook manually from the command-line when needed (see `pre-commit help run`)

##### error-on-output

Some tools, like `gofmt`, `goimports`, and `goreturns`, don't generate error codes, but instead expect the presence of any output to indicate warning/error conditions.

The my-cmd hooks accept a `--hook:error-on-output` argument to indicate this behavior.

Here's an example of what it would look like to use the my-cmd hooks to invoke `gofmt` if it wasn't already included:

_.pre-commit-config.yaml_
```
# ...
      hooks:
            # Run 'gofmt -l -d $FILE' for each staged .go file
            # Treat any output as indication of failure
        -   id: my-cmd
            name: go-fmt
            alias: go-fmt
            args: [ gofmt, -l, -d, --hook:error-on-output]
```

**NOTE:** The plain `--error-on-output` option is now deprecated, but still supported, as long as it's the **very first** entry in the `args:` list.

----------
## License

The `tekwizely/pre-commit-golang` project is released under the [MIT](https://opensource.org/licenses/MIT) License.  See `LICENSE` file.
