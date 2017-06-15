#!/usr/bin/env ruby
this_dir = __dir__() + '/'
cwd = Dir.pwd() + '/'
require_relative this_dir + '../lib/create_feature_branch_pipeline'

branch_list_filename = cwd + ARGV[0]
target_file = cwd + ARGV[1]
branches = File.readlines branch_list_filename
jobs_template = this_dir + '../pipelines/feature-branch-pipeline-jobs.yml.erb'
resources_template = this_dir + '../pipelines/feature-branch-pipeline-resources.yml.erb'

CreateFeatureBranchPipeline.createFrom(jobs_template,
                                       resources_template,
                                       target_file,
                                       branches)

puts File.read(target_file)