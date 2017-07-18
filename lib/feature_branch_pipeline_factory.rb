require 'yaml'

class FeatureBranchPipelineFactory

  def initialize(branches_list, jobs_renderer, resources_renderer)
    @branches_list = branches_list
    @jobs_renderer = jobs_renderer
    @resources_renderer = resources_renderer
  end

  def construct_pipeline_for_branches
    constructed_pipeline = {'jobs' => [], 'resources' => []}

    source_name = 'pivotal-'
    git_uri = 'https://github.com/greenplum-db/pgadmin4.git'
    @branches_list.each do |branch|
      add_branch_entry_to_section(@jobs_renderer, git_uri, source_name,branch, constructed_pipeline['jobs'])
      add_branch_entry_to_section(@resources_renderer, git_uri, source_name, branch, constructed_pipeline['resources'])
    end

    source_name = 'pgadmin-'
    branch = 'master'
    git_uri = 'git://git.postgresql.org/git/pgadmin4.git'
    add_branch_entry_to_section(@jobs_renderer, git_uri, source_name,branch, constructed_pipeline['jobs'])
    add_branch_entry_to_section(@resources_renderer, git_uri, source_name, branch, constructed_pipeline['resources'])

    constructed_pipeline
  end

  def add_branch_entry_to_section(renderer, git_uri, source_name, branch_name, pipeline_yaml_section)
    renderer_binding = binding.clone
    renderer_binding.local_variable_set(:render_branch_name, branch_name)
    renderer_binding.local_variable_set(:source_name, source_name)
    renderer_binding.local_variable_set(:git_uri, git_uri)
    yaml_section = YAML.load renderer.result(renderer_binding)

    yaml_section.each { |entry|
      add_entry_if_unique_by_name(entry, pipeline_yaml_section)
    }
  end

  def add_entry_if_unique_by_name(entry, target)
    target_entry_names = target.map { |existing| existing['name'] }
    unless target_entry_names.include? entry['name']
      target.push entry
    end
  end

end