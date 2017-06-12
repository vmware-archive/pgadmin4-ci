require 'erb'
require 'yaml'

class CreateFeatureBranchPipeline
  def self.createFrom(yaml_erb_input_path, yaml_destination_path, branches_list)
    branches = branches_list.map { |branch| branch.strip()}

    template = File.read(yaml_erb_input_path)

    constructed_yaml = construct_jobs_for_branches(branches, template)

    File.open(yaml_destination_path, 'w') do |f|
      f.write "# GENERATED, DO NOT TOUCH.\n"
      f.write "# SEE feature-branch-pipeline.yml.erb and create_pipeline.rb in tasks/\n"
      f.write YAML.dump(constructed_yaml)
    end
  end

  def self.construct_jobs_for_branches(branches_list, template)
    renderer = ERB.new(template)
    constructed_yaml = {'jobs' => []}

    branches_list.each do |branch|
      render_branch_name = branch
      templated_yaml = YAML.load renderer.result(binding)
      job_for_branch = templated_yaml['jobs'][0]
      constructed_yaml['jobs'].push job_for_branch
    end
    constructed_yaml
  end

end