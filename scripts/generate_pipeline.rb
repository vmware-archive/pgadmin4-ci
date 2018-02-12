#!/usr/bin/env ruby
this_dir = __dir__() + '/'
cwd = Dir.pwd() + '/'
require_relative this_dir + '../lib/feature_branch_pipeline_creator'

branch_list_filename = cwd + ARGV[0]
target_file = cwd + ARGV[1]
config_file = cwd + ARGV[2]
branches = File.readlines branch_list_filename

branches = branches.select{ |i| !i[/default/] }
branches = branches.select{ |i| !i[/electron/] }
branches = branches.select{ |i| !i[/autoformat/] }

jobs_template = this_dir + '../pipelines/feature-branch-pipeline-jobs.yml.erb'
resources_template = this_dir + '../pipelines/feature-branch-pipeline-resources.yml.erb'
static_pipeline_content = File.read this_dir + '../pipelines/static-generated-pipeline-header.yml'
concourse_config = {
  'gpdb_host' => ENV['GPDB_HOST'],
  'gpdb_username' => ENV['GPDB_USERNAME'],
  'gpdb_password' => ENV['GPDB_PASSWORD'],
  'gpdb_port' => ENV['GPDB_PORT'],
  'pws_username' => ENV['PWS_USERNAME'],
  'pws_password' => ENV['PWS_PASSWORD'],
  'pws_org' => ENV['PWS_ORG'],
  'pws_space' => ENV['PWS_SPACE'],
}

pipeline_creator = FeatureBranchPipelineCreator.new(branches,
                                                    static_pipeline_content,
                                                    jobs_template,
                                                    resources_template,
                                                    target_file,
                                                    concourse_config,
                                                    config_file)
pipeline_creator.create

puts File.read(target_file)
