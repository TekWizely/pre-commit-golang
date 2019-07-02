# Pre-Commit-GoLang [![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/tekwizely/pre-commit-golang/blob/master/LICENSE)

A set of git pre-commit hooks for Golang projects.

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
    # Consider adding aliases to longer-named hooks for easier CLI usage.
    # ==========================================================================
-   repo: https://github.com/tekwizely/pre-commit-golang
    rev: master
    hooks:
    #
    # Go Build
    #
    -   id: go-build-mod
    -   id: go-build-dir
    -   id: go-build-pkg
    -   id: go-build-repo
    -   id: go-build-repo-dir
    -   id: go-build-repo-pkg
    #
    # Go Test
    #
    -   id: go-test-mod
    -   id: go-test-dir
    -   id: go-test-pkg
    -   id: go-test-repo
    -   id: go-test-repo-dir
    -   id: go-test-repo-pkg
    #
    # Go Vet
    #
    -   id: go-vet
    -   id: go-vet-mod
    -   id: go-vet-dir
    -   id: go-vet-pkg
    -   id: go-vet-repo
    -   id: go-vet-repo-dir
    -   id: go-vet-repo-pkg
    #
    # Formatters
    #
    -   id: go-fmt-fix
    -   id: go-imports-fix # replaces go-fmt-fix
    -   id: go-returns-fix # replaces go-imports-fix & go-fmt-fix
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
    -   id: golangci-lint-fix
    -   id: golangci-lint-mod
    -   id: golangci-lint-mod-fix
    -   id: golangci-lint-dir
    -   id: golangci-lint-dir-fix
    -   id: golangci-lint-pkg
    -   id: golangci-lint-pkg-fix
    -   id: golangci-lint-repo
    -   id: golangci-lint-repo-fix
```

-----------
## Overview

### Staged Files
Unless configured to `"always_run"` (see below), hooks ONLY run when
matching file types (usually `*.go`) are staged.

--------------------
### File-Based Hooks
By default, hooks run against matching staged files individually.

#### No User Args
Currently, file-based hooks DO NOT accept user-args.

-------------------------
### Directory-Based Hooks
Some hooks work on a per-directory basis.  The hooks run against the directory containing one or more matching staged files.

#### No User Args
Currently, directory-based hooks DO NOT accept user-args.

#### Directory-Hook Suffixes
 - `*-mod-*` : Hook runs inside first module root directory going up $FILE path.
 - `*-dir-*` : Hook runs using `./$(dirname $FILE)` as target.
 - `*-pkg-*` : Hook runs using `'$(go list)/$(dirname $FILE)` as target.

#### Multiple Hook Invocations
By design, the directory-based hooks only execute against a given directory once per hook invocation.

HOWEVER, due to OS command-line length limits, Pre-Commit can invoke a hook multiple times if a large number of files are staged.

--------------------
### Repo-Based Hooks
Hooks named `'*-repo-*'` only run once (if any matching files are staged).  They are NOT provided the list of staged files and are more full-repo oriented.

#### User args
Generally, repo-based hooks DO accept user-args.

#### Repo-Hook Suffixes
 - `*-repo`     : Hook runs with no target argument (good for adding custom arguments / targets)
 - `*-repo-dir` : Hook runs using `'./...'` as target.
 - `*-repo-pkg` : Hook runs using `'$(go list)/...'` as target.

--------------
### Fix Suffix
Hooks named `'*-fix'` fix (modify) files directly, when possible.

-----------
### Aliases
Consider adding aliases to longer-named hooks for easier CLI usage.

--------------------------
### Useful Hook Parameters
```
-   id: hook-id
    alias: hook-alias       # Create an alias
    args: [arg1, arg2, ...] # Pass arguments
    always_run: true        # Run even if no matching files staged
```

--------
## Hooks

 - [Go Build](#go-build-repo-)
 - [Go Test](#go-test-repo-)
 - [Go Vet](#go-vet--go-vet-repo-)
 - Formatters
   - [go-fmt](#go-fmt-fix)
   - [go-imports](#go-imports-fix)
   - [go-returns](#go-returns-fix)
 - Style Checkers
   - [go-lint](#go-lint)
   - [go-critic](#go-critic)
 - [GoLangCI-Lint](#golangci-lint)

-------------------
### go-build-repo-*

#### Directory-Based Hooks
  - `go-build-mod`
  - `go-build-dir`
  - `go-build-pkg`

#### Repo-Based Hooks
 - `go-build-repo`
 - `go-build-repo-dir`
 - `go-build-repo-pkg`

#### Install
Comes with Golang ( [golang.org](https://golang.org/) )

#### Help
 - https://golang.org/cmd/go/#hdr-Compile_packages_and_dependencies
 - `go help build`

------------------
### go-test-repo-*

#### Directory-Based Hooks
 - `go-test-mod`
 - `go-test-dir`
 - `go-test-pkd`

#### Repo-Based Hooks
 - `go-test-repo`
 - `go-test-repo-dir`
 - `go-test-repo-pkg`

#### Install
Comes with Golang ( [golang.org](https://golang.org/) )

#### Help
 - https://golang.org/cmd/go/#hdr-Test_packages
 - `go help test`

--------------------------
### go-vet / go-vet-repo-*

#### File-Based Hooks
 - `go-vet` - Runs against staged `.go` files

#### Directory-Based Hooks
 - `go-vet-mod`
 - `go-vet-dir`
 - `go-vet-pkg`

#### Repo-Based Hooks
 - `go-vet-repo`
 - `go-vet-repo-dir`
 - `go-vet-repo-pkg`

#### Install
Comes with Golang ( [golang.org](https://golang.org/) )

#### Help
 - https://golang.org/cmd/go/#hdr-Report_likely_mistakes_in_packages
 - `go help vet`
 - `go tool vet help`

--------------
### go-fmt-fix
 - File-based
 - Modifies (fixes) files

#### Install
Comes with Golang ( [golang.org](https://golang.org/) )

#### Useful Args
```
-s : Try to simplify code
```

#### Help
 - https://godoc.org/github.com/golang/go/src/cmd/gofmt
 - `gofmt -h`

------------------
### go-imports-fix
 - Replaces `go-fmt-fix`
 - File-based
 - Modifies (fixes) files

#### Install
```
go get -u golang.org/x/tools/cmd/goimports
```

#### Useful Args
```
-format-only    : Do not fix imports, act ONLY as go-fmt
-local prefixes : Add imports matching prefix AFTER 3rd party packages
                  (prefixes = comma-separated list)
-v              : Verbose logging
```

#### Help
 - https://godoc.org/golang.org/x/tools/cmd/goimports
 - `goimports -h`

------------------
### go-returns-fix

 - Replaces `go-fmt-fix`
 - Replaces `go-imports-fix` (can be disabled)
 - File-based
 - Modifies (fixes) files

#### Install
```
go get -u github.com/sqs/goreturns
```

#### Useful Args
```
-b              : Remove bare returns
-i=false        : Disable go-imports
-local prefixes : Add imports matching prefix AFTER 3rd party packages
                  (prefixes = comma-separated list)
-p              : Print non-fatal type-checking errors to STDERR
```

#### Help
 - https://godoc.org/github.com/sqs/goreturns
 - `goreturns -h`

-----------
### go-lint

 - File-based

#### Install
```
go get -u golang.org/x/lint/golint
```

#### Help
 - https://godoc.org/golang.org/x/lint
 - `golint -h`

-------------
### go-critic

 - File-based

#### Install
   https://github.com/go-critic/go-critic#installation

#### Useful Args
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
 - Manages multiple linters
 - Can replace many/most other hooks
 - Can modify files
 - File-based

#### File-Based Hooks
- `golangci-lint`
- `golangci-lint-fix`

#### Directory-Based Hooks
- `golangci-lint-mod`
- `golangci-lint-mod-fix`
- `golangci-lint-dir`
- `golangci-lint-dir-fix`
- `golangci-lint-pkg`
- `golangci-lint-pkg-fix`

#### Repo-Based Hooks
- `golangci-lint-repo`
- `golangci-lint-repo-fix`

#### Install
```
go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
```
#### Useful Args
```
   --fast            : Run only fast linters (from enabled linters sets)
   --fix             : Fix found issues (if supported by linter)
   --enable-all      : Enable ALL linters
   --enable linters  : Enable specific linter(s)
   --disable linters : Disable specific linter(s)
   --presets presets : Enable presets of linters
   --config PATH     : Specify config file
   --no-config       : don't read config file
```
**Presets**
 - `bugs`
 - `complexity`
 - `format`
 - `performance`
 - `style`
 - `unused`

#### Help
 - https://github.com/golangci/golangci-lint#quick-start
 - `golangci-lint run -h`

#### Config File Help:
 - https://github.com/golangci/golangci-lint#config-file
 - `golangci-lint config -h`

----------
## License

The `tekwizely/pre-commit-golang` project is released under the [MIT](https://opensource.org/licenses/MIT) License.  See `LICENSE` file.
