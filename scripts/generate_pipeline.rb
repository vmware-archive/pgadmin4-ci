#!/usr/bin/env ruby
this_dir = __dir__() + '/'
cwd = Dir.pwd() + '/'
require_relative this_dir + '../lib/create_feature_branch_pipeline'

branch_list_filename = cwd + ARGV[0]
target_file = cwd + ARGV[1]
branches = File.readlines branch_list_filename

CreateFeatureBranchPipeline.createFrom(this_dir + '../pipelines/feature-branch-pipeline.yml.erb',
                                       target_file,
                                       branches)