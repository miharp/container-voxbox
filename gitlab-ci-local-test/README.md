# voxbox + gitlab-ci-local test harness

A self-contained sample Puppet module to reproduce and verify the voxbox
GitLab CI lint setup locally, without pushing to GitLab.

## Layout

```
gitlab-ci-local-test/
├── .gitlab-ci.yml      # corrected pipeline (entrypoint blanked, /opt/voxbox/Rakefile)
├── metadata.json       # minimal module metadata
└── manifests/
    └── init.pp         # class `example`, lints clean by default
```

## Prerequisites

- Docker running locally
- [`gitlab-ci-local`](https://github.com/firecow/gitlab-ci-local):
  `brew install gitlab-ci-local`

## Run it

```sh
cd gitlab-ci-local-test
gitlab-ci-local                 # run the whole pipeline
gitlab-ci-local lint:puppet     # run just the lint job
```

Expected: `lint:puppet` passes (green), because `manifests/init.pp` is
lint-clean against all puppet-lint checks.

## Make it fail (to prove the lint actually runs)

Edit `manifests/init.pp` and add a violation, e.g. a line over 140
characters or a double-quoted string with no variable, then re-run.
The job should fail with puppet-lint output.

## Run the lint directly (no gitlab-ci-local)

Same thing the pipeline does, straight through Docker:

```sh
docker run --rm -v "$PWD:/repo" \
  --entrypoint bundle \
  ghcr.io/voxpupuli/voxbox:latest \
  exec rake -f /opt/voxbox/Rakefile voxpupuli:custom:lint_all
```

## Notes

- The container entrypoint is `bundle exec rake -f /opt/voxbox/Rakefile`,
  so under normal `docker run` you just pass a task name. Under GitLab CI
  you must blank the entrypoint (`entrypoint: [""]`) so the runner can
  execute your `script:`, then call rake yourself.
- On older images the Rakefile lived at `/Rakefile`. On current `:latest`
  it is `/opt/voxbox/Rakefile`.
