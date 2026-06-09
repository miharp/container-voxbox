# @summary A minimal example class used to exercise voxbox linting.
#
# This manifest intentionally lints clean against
# `voxpupuli:custom:lint_all` (all puppet-lint checks enabled). To see
# the pipeline catch a problem, introduce a lint violation here (for
# example a line longer than 140 characters, or a double-quoted string
# without a variable) and re-run the job.
#
# @param manage
#   Whether to manage the example file.
class example (
  Boolean $manage = true,
) {
  if $manage {
    file { '/tmp/example':
      ensure => 'file',
    }
  }
}
