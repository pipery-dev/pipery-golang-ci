# Pipery Go CI

CI pipeline for Go: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-golang-ci`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-golang-ci@v0
        with:
          project_path: .
```

## Inputs

### Core

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to Pipery config file. |
| `log_file` | `pipery.jsonl` | Path to the JSONL log file written during the run. |
| `go_version` | `1.22` | Go version to use. |

### Registry / publish credentials

| Name | Default | Description |
|---|---|---|
| `registry` | `ghcr.io` | Container registry for packaging. |
| `image_name` | `` | Container image name. |
| `github_token` | `` | GitHub token for release and reintegration steps. |

### Pipeline controls (skip flags)

| Name | Default | Description |
|---|---|---|
| `skip_sast` | `false` | Skip SAST step. |
| `skip_sca` | `false` | Skip SCA step. |
| `skip_lint` | `false` | Skip lint step. |
| `skip_build` | `false` | Skip build step. |
| `skip_test` | `false` | Skip test step. |
| `skip_versioning` | `false` | Skip versioning step. |
| `skip_packaging` | `false` | Skip packaging step. |
| `skip_release` | `false` | Skip release step. |
| `skip_reintegration` | `false` | Skip reintegration step. |

### Versioning & release

| Name | Default | Description |
|---|---|---|
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |

### Testing

| Name | Default | Description |
|---|---|---|
| `tests_path` | `./...` | Go package path for tests (e.g. `./pkg/...`). Defaults to `./...`. |

## Outputs

| Name | Description |
|---|---|
| `version` | The new version string after the versioning step. |

## Steps

| Step | Skip flag | What it does |
|---|---|---|
| SAST | `skip_sast` | Static analysis via pipery-steps |
| SCA | `skip_sca` | Dependency vulnerability scan |
| Lint | `skip_lint` | Language-specific linting via golangci-lint, falling back to `go vet` |
| Build | `skip_build` | Compile the Go binary |
| Test | `skip_test` | Run `go test` against `tests_path` |
| Versioning | `skip_versioning` | Bump version, write to `GITHUB_OUTPUT` |
| Packaging | `skip_packaging` | Cross-compile binaries for linux/darwin/windows-amd64 |
| Release | `skip_release` | Publish GitHub release with `sha-<shortsha>` in the title |
| Reintegration | `skip_reintegration` | Merge release branch back to default |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions release --repo . --dry-run
```
