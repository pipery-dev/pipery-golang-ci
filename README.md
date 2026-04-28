# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-golang-ci/main/assets/icon.png" width="28" align="center" /> Pipery Go CI

Reusable GitHub Action for a complete Go CI pipeline with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Go%20CI-blue?logo=github)](https://github.com/marketplace/actions/pipery-go-ci)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-golang-ci@v1
        with:
          project_path: .
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Pipeline steps

| Step | Tool | Skip input |
|---|---|---|
| SAST | Gosec | `skip_sast` |
| SCA | Nancy / govulncheck | `skip_sca` |
| Lint | golangci-lint / go vet | `skip_lint` |
| Build | `go build` | `skip_build` |
| Test | `go test` | `skip_test` |
| Version | Semantic version bump | `skip_versioning` |
| Package | Cross-compile binaries | `skip_packaging` |
| Release | GitHub Release + SHA tag | `skip_release` |
| Reintegrate | Merge back to default branch | `skip_reintegration` |

## Inputs

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to Pipery config file. |
| `go_version` | `1.22` | Go version to use. |
| `tests_path` | `./...` | Go package path passed to `go test`. |
| `registry` | `ghcr.io` | Container registry for packaging. |
| `image_name` | `` | Container image name. |
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `github_token` | `` | GitHub token for release and reintegration. |
| `log_file` | `pipery.jsonl` | Path to the JSONL structured log file. |
| `skip_sast` | `false` | Skip the SAST step. |
| `skip_sca` | `false` | Skip the SCA step. |
| `skip_lint` | `false` | Skip the lint step. |
| `skip_build` | `false` | Skip the build step. |
| `skip_test` | `false` | Skip the test step. |
| `skip_versioning` | `false` | Skip the versioning step. |
| `skip_packaging` | `false` | Skip the packaging step. |
| `skip_release` | `false` | Skip the release step. |
| `skip_reintegration` | `false` | Skip the reintegration step. |

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
