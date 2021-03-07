# Pre-Commit-GoLang [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A set of git pre-commit hooks for Golang with support for Modules.

Requires the [Pre-Commit.com](https://pre-commit.com) Hook Management framework.

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
    # GoSec
    #
    -   id: go-sec-mod
    -   id: go-sec-pkg
    -   id: go-sec-repo-mod
    -   id: go-sec-repo-pkg
    #
    # Formatters
    #
    -   id: go-fmt
    -   id: go-imports # replaces go-fmt
    -   id: go-returns # replaces go-imports & go-fmt
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
| `-repo-mod` | All Modules  | Targets all module root folders in the repo       |
| `-repo-pkg` | All Packages | Targets all package folders in the repo           |

-----------------------------
### Multiple Hook Invocations
Due to OS command-line-length limits, Pre-Commit can invoke a hook multiple times if a large number of files are staged.

For file and repo-based hooks, this isn't an issue, but for module and package-based hooks, there is a potential for the hook to run against the same module or package multiple times, duplicating any errors or warnings.

--------------------------
### Useful Hook Parameters
```
-   id: hook-id
    args: [arg1, arg2, ..., '--'] # Pass options ('--' is optional)
    always_run: true              # Run even if no matching files staged
    alias: hook-alias             # Create an alias
```

#### Passing Options To Hooks
You can pass options into individual hooks to customize tool behavior.

If your options contain a reference to an existing file, then you
will need to use a trailing `'--'` argument to separate the hook options from
the modified-file list that Pre-Commit passes into the hook.

**NOTE:** For repo-based hooks, `'--'` is not needed.

See each hook's description below for some popular options that you might want to use.

Additionally, you can view each tool's individual home page or help settings to learn about all the available options.

#### Always Run
By default, hooks ONLY run when matching file types (usually `*.go`) are staged.

When configured to `"always_run"`, a hook is executed as if EVERY matching file were staged.

#### Aliases
Consider adding aliases to longer-named hooks for easier CLI usage.

--------
## Hooks

 - Correctness Checkers
   - [go-build](#go-build)
   - [go-test](#go-test)
   - [go-vet](#go-vet)
   - [go-sec](#go-sec)
 - Formatters
   - [go-fmt](#go-fmt)
   - [go-imports](#go-imports)
   - [go-returns](#go-returns)
 - Style Checkers
   - [go-lint](#go-lint)
   - [go-critic](#go-critic)
 - GolangCI-Lint
   - [golangci-lint](#golangci-lint)

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

-----------
### go-test
Automates testing, printing a summary of test resutls.

| Hook ID            | Description
|--------------------|------------
| `go-test-mod`      | Run `'cd $(mod_root $FILE); gosec [$ARGS] ./...'` for each staged .go file
| `go-test-pkg`      | Run `'gosec [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-test-repo-mod` | Run `'cd $(mod_root); gosec [$ARGS] ./...'` for each module in the repo
| `go-test-repo-pkg` | Run `'gosec [$ARGS] ./...'` in repo root folder

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Help
 - https://golang.org/cmd/go/#hdr-Test_packages
 - `go help test`

-----------
### go-sec
Inspects source code for security problems by scanning the Go AST.

| Hook ID           | Description
|-------------------|------------
| `go-sec-mod`      | Run `'cd $(mod_root $FILE); gosec [$ARGS] ./...'` for each staged .go file
| `go-sec-pkg`      | Run `'gosec [$ARGS] ./$(dirname $FILE)'` for each staged .go file
| `go-sec-repo-mod` | Run `'cd $(mod_root); gosec [$ARGS] ./...'` for each module in the repo
| `go-sec-repo-pkg` | Run `'gosec [$ARGS] ./...'` in repo root folder

##### Install
```
go get github.com/securego/gosec/v2/cmd/gosec
```

##### Help
 - https://github.com/securego/gosec#usage
 - `gosec (no args)`

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

| Hook ID  | Description
|----------|------------
| `go-fmt` | Run `'gofmt -l -d [$ARGS] $FILE'` for each staged .go file

##### Install
Comes with Golang ( [golang.org](https://golang.org/) )

##### Useful Args
```
-d=false : Don't display diffs
-s       : Try to simplify code
-w       : Update source file directly
```

##### Help
 - https://godoc.org/github.com/golang/go/src/cmd/gofmt
 - `gofmt -h`

--------------
### go-imports
Updates your Go import lines, adding missing ones and removing unreferenced ones.

 - Replaces `go-fmt`
 - Can modify files (see `-w`)

| Hook ID      | Description
|--------------|------------
| `go-imports` | Run `'goimports -l -d [$ARGS] $FILE'` for each staged .go file

##### Install
```
go get -u golang.org/x/tools/cmd/goimports
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

| Hook ID      | Description
|--------------|------------
| `go-returns` | Run `'goreturns -l -d [$ARGS] $FILE'` for each staged .go file

##### Install
```
go get -u github.com/sqs/goreturns
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

##### Install
```
go get -u golang.org/x/lint/golint
```

##### Help
 - https://godoc.org/golang.org/x/lint
 - `golint -h`
 - https://golang.org/doc/effective_go.html
 - https://golang.org/wiki/CodeReviewComments

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

##### Install
```
go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
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
## License

The `tekwizely/pre-commit-golang` project is released under the [MIT](https://opensource.org/licenses/MIT) License.  See `LICENSE` file.
