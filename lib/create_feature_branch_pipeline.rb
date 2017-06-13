require 'erb'
require 'yaml'
require 'json'

class CreateFeatureBranchPipeline
  def self.createFrom(yaml_erb_input_path, resources_template_path, yaml_destination_path, branches_list)
    branches = branches_list.map { |branch| branch.strip() }

    template = File.read(yaml_erb_input_path)

    constructed_yaml = construct_jobs_for_branches(branches, template, resources_template_path)

    File.open(yaml_destination_path, 'w') do |f|
      f.write "# GENERATED, DO NOT TOUCH.\n"
      f.write "# SEE feature-branch-pipeline.yml.erb and create_pipeline.rb in tasks/\n"
      f.write YAML.dump(constructed_yaml)
    end
  end

  def self.construct_jobs_for_branches(branches_list, template, resources_template_path)
    renderer = ERB.new(template)
    constructed_yaml = {'jobs' => []}

    resources = YAML.load(File.read(resources_template_path))
    constructed_yaml['resources'] = resources['resources']

    branches_list.each do |branch|
      render_branch_name = branch
      templated_yaml = YAML.load renderer.result(binding)
      jobs_for_branch = templated_yaml['jobs']

      jobs_for_branch.each { |job|
        constructed_yaml['jobs'].push job
      }
    end

    constructed_yaml
  end
end