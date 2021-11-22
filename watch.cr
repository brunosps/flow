require "watch"
require "process"

test_cmd = "crystal spec"

Watch.watch "./spec/**/*.cr", test_cmd
Watch.watch "./src/**/*.cr", test_cmd

Process.run test_cmd, shell: true, error: STDERR, output: STDOUT

Watch.run
