# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-golang-ci/main/assets/icon.png" alt="Pipery Go CI" width="28" align="center" /> Pipery Go CI

Reusable GitHub Action for a complete Go CI pipeline with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Go%20CI-blue?logo=github)](https://github.com/marketplace/actions/pipery-golang-ci)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

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

## Pipeline Overview

| Step | Tool | Skip Input | Description |
| --- | --- | --- | --- |
| SAST | gosec | `skip_sast` | Detects Go security issues |
| SCA | nancy / go list | `skip_sca` | Identifies vulnerable dependencies |
| Lint | golangci-lint | `skip_lint` | Enforces code style and quality |
| Build | `go build` | `skip_build` | Compiles Go binary |
| Test | `go test` | `skip_test` | Runs unit and integration tests |
| Version | Semantic versioning | `skip_versioning` | Bumps version and creates git tag |
| Package | `go build -o` / Docker | `skip_packaging` | Creates distributable artifacts |
| Release | GitHub Release | `skip_release` | Publishes binaries to GitHub |
| Reintegrate | Git merge | `skip_reintegration` | Merges back to default branch |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `go_version` | `1.22` | Go version to use (e.g., `1.20`, `1.22`, `1.23`). |
| `tests_path` | `./...` | Go package path for tests (e.g., `./pkg/...`). |
| `target_platforms` | `` | Comma or whitespace separated `GOOS/GOARCH` targets for cross-platform compilation, e.g. `linux/amd64,darwin/arm64,windows/amd64`. Empty builds the host platform; packaging defaults to `linux/amd64,darwin/amd64,windows/amd64`. |
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `github_token` | `` | GitHub token for release and reintegration. |
| `registry` | `ghcr.io` | Container registry for packaging. |
| `image_name` | `` | Container image name (if packaging as Docker). |
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

## Usage Examples

### Example 1: Basic Go module with all steps

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
          go_version: "1.22"
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 2: Run specific test packages

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    tests_path: ./pkg/... ./cmd/...
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 3: Cross-platform binaries

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    target_platforms: linux/amd64,linux/arm64,darwin/arm64,windows/amd64
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 4: Skip security scanning

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    skip_sast: true
    skip_sca: true
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 5: Go 1.20 with binary release

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    go_version: "1.20"
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 6: Docker image packaging

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    registry: ghcr.io
    image_name: ${{ github.repository }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 6: Minor version bump for release

```yaml
- uses: pipery-dev/pipery-golang-ci@v1
  with:
    project_path: .
    version_bump: minor
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-golang-ci/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `GITHUB_TOKEN` - GitHub API access for release and reintegration
- `GO_VERSION` - Go version (default: 1.22)
- `VERSION_BUMP` - patch/minor/major (default: patch)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `GITHUB_TOKEN` - GitHub API access (for release and reintegration)
   - `GO_VERSION` - Go version (default: 1.22)
3. Commit and push to trigger the pipeline

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → SAST (gosec) → SCA (nancy) → lint (golangci-lint) → build → test → versioning → packaging → release → reintegration → logs

### Skip Flags

Disable any stage using environment variables:

- `SKIP_SAST`, `SKIP_SCA`, `SKIP_LINT`, `SKIP_BUILD`, `SKIP_TEST`, `SKIP_VERSIONING`, `SKIP_PACKAGING`, `SKIP_RELEASE`, `SKIP_REINTEGRATION`

Example: Set `SKIP_SAST=true` to skip security scanning.

### Features

- Security scanning (gosec, nancy)
- Code quality linting (golangci-lint)
- Cross-platform binary builds
- Docker image packaging support
- Automatic GitHub releases
- JSONL-based pipeline logging
- 30-90 day artifact retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

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
