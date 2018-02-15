require 'erb'
require 'yaml'
require_relative './feature_branch_pipeline_factory'

class FeatureBranchPipelineCreator

  def initialize(branch_list, static_header, jobs_template_path, resources_template_path, destination_pipeline_path, concourse_config, concourse_config_path)
    branches = branch_list.map(&:strip)
    jobs_renderer = ERB.new File.read(jobs_template_path)
    resources_renderer = ERB.new File.read(resources_template_path)
    @destination_pipeline_path = destination_pipeline_path
    @concourse_config_path = concourse_config_path
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
    File.open(@concourse_config_path, 'w') do |f|
      f.write @concourse_config.to_yaml
    end
  end

  def write_pipeline_to_disk(constructed_yaml)
    File.open(@destination_pipeline_path, 'w') do |f|
      f.write @static_header
      yaml_string = YAML.dump(constructed_yaml)
      yaml_string = yaml_string.gsub('GPDB_HOST', '{{gpdb_host}}')
        .gsub('GPDB_USERNAME', '{{gpdb_username}}')
        .gsub('GPDB_PASSWORD', '{{gpdb_password}}')
        .gsub('GPDB_PORT', '{{gpdb_port}}')
        .gsub('PWS_USERNAME', '{{pws_username}}')
        .gsub('PWS_PASSWORD', '{{pws_password}}')
        .gsub('PWS_ORG', '{{pws_org}}')
        .gsub('PWS_SPACE', '{{pws_space}}')
        .gsub('TRACKER_TOKEN', '{{tracker_token}}')
      f.write yaml_string
    end
  end
end
