#!/usr/bin/env ruby
require 'yaml'
require 'byebug'

$concourse_target = ARGV[0]
$pipeline_name = ARGV[1]

def get_pipeline_config
  `fly -t #{$concourse_target} get-pipeline -p #{$pipeline_name}`
end

def list_of_jobs_from_config(pipeline_yaml)
  pipeline_yaml['jobs'].map { |job| job['name'] }
end

def pause_job(job)
  `fly -t #{$concourse_target} pause-job -j #{$pipeline_name}/#{job}`
end

pipeline_yaml = YAML.load get_pipeline_config

job_names = list_of_jobs_from_config pipeline_yaml
placeholder_jobs = job_names.select { |job| return job.include? '-branch' }
placeholder_jobs.each { |job| pause_job(job) }
