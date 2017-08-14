require 'erb'
require 'yaml'
require_relative './feature_branch_pipeline_factory'

class FeatureBranchPipelineCreator

  def initialize(branch_list, static_header, jobs_template_path, resources_template_path, destination_pipeline_path, concourse_config)
    branches = branch_list.map(&:strip)
    jobs_renderer = ERB.new File.read(jobs_template_path)
    resources_renderer = ERB.new File.read(resources_template_path)
    @destination_pipeline_path = destination_pipeline_path
    @static_header = static_header
    @concourse_config = concourse_config

    @pipeline_factory = FeatureBranchPipelineFactory.new(branches, jobs_renderer, resources_renderer)
  end

  def create
    constructed_yaml = @pipeline_factory.construct_pipeline_for_branches

    write_pipeline_to_disk(constructed_yaml)
    write_concourse_config_to_disk
  end

  def write_concourse_config_to_disk
    File.open('concourse-config.yml', 'w') do |f|
      f.write @concourse_config.to_yaml
    end
  end

  def write_pipeline_to_disk(constructed_yaml)
    File.open(@destination_pipeline_path, 'w') do |f|
      f.write @static_header
      f.write YAML.dump(constructed_yaml)
    end
  end
end