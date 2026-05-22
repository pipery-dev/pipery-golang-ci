# Pipery Go CI

CI pipeline for Go: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-golang-ci`
- Marketplace category: `continuous-integration`
- Current version: `1.0.6`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-golang-ci@v1
        with:
          project_path: .
          config_file: .pipery/config.yaml
          go_version: 1.22
          skip_sast: false
          skip_sca: false
          skip_lint: false
          skip_build: false
          tests_path: ./...
          target_platforms: 
          skip_test: false
          skip_versioning: false
          skip_packaging: false
          skip_release: false
          skip_reintegration: false
          version_bump: patch
          github_token: 
          log_file: pipery.jsonl
          registry: ghcr.io
          image_name: 
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree the action should operate on. |
| `config_file` | no | `.pipery/config.yaml` | Path to Pipery config file. |
| `go_version` | no | `1.22` | Go version to use. |
| `skip_sast` | no | `false` | Skip SAST step. |
| `skip_sca` | no | `false` | Skip SCA step. |
| `skip_lint` | no | `false` | Skip lint step. |
| `skip_build` | no | `false` | Skip build step. |
| `tests_path` | no | `./...` | Go package path for tests (e.g. ./pkg/...). Defaults to ./... |
| `target_platforms` | no | `` | Comma or whitespace separated GOOS/GOARCH targets for cross-platform compilation, e.g. linux/amd64,darwin/arm64,windows/amd64. Empty builds the host platform. |
| `skip_test` | no | `false` | Skip test step. |
| `skip_versioning` | no | `false` | Skip versioning step. |
| `skip_packaging` | no | `false` | Skip packaging step. |
| `skip_release` | no | `false` | Skip release step. |
| `skip_reintegration` | no | `false` | Skip reintegration step. |
| `version_bump` | no | `patch` | Version bump type: patch, minor, or major. |
| `github_token` | no | `` | GitHub token for release and reintegration steps. |
| `log_file` | no | `pipery.jsonl` | Path to the JSONL log file written during the run. |
| `registry` | no | `ghcr.io` | Container registry for packaging. |
| `image_name` | no | `` | Container image name. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
