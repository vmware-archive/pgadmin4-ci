require 'erb'
require 'yaml'

class CreateFeatureBranchPipeline
  def self.createFrom(jobs_template_path, resources_template_path, destination_pipeline_path, branch_list)
    branches = branch_list.map { |branch| branch.strip() }
    jobs_renderer = ERB.new File.read(jobs_template_path)
    resources_renderer = ERB.new File.read(resources_template_path)

    constructed_yaml = construct_pipeline_for_branches(branches, jobs_renderer, resources_renderer)

    File.open(destination_pipeline_path, 'w') do |f|
      f.write "# GENERATED, DO NOT TOUCH.\n"
      f.write "# SEE feature-branch-pipeline.yml.erb and create_pipeline.rb in tasks/\n"
      f.write YAML.dump(constructed_yaml)
    end
  end

  def self.construct_pipeline_for_branches(branches_list, jobs_renderer, resources_renderer)
    constructed_pipeline = {'jobs' => [], 'resources' => []}

    branches_list.each do |branch|
      add_branch_entry_to_section(jobs_renderer, branch, constructed_pipeline['jobs'])
      add_branch_entry_to_section(resources_renderer, branch, constructed_pipeline['resources'])
    end

    constructed_pipeline
  end

  def self.add_branch_entry_to_section(renderer, branch_name, pipeline_yaml_section)
    renderer_binding = binding.clone
    renderer_binding.local_variable_set(:render_branch_name, branch_name)
    yaml_section = YAML.load renderer.result(renderer_binding)

    yaml_section.each { |entry|
      add_entry_if_unique_by_name(entry, pipeline_yaml_section)
    }
  end

  def self.add_entry_if_unique_by_name(entry, target)
    target_entry_names = target.map { |existing| existing['name'] }
    unless target_entry_names.include? entry['name']
      target.push entry
    end
  end
end