require 'rspec'
require 'create_feature_branch_pipeline'

describe 'create' do

  it 'should output valid yaml' do
    template = Dir.pwd() + '/pipelines/feature-branch-pipeline.yml.erb'
    resources = Dir.pwd() + '/pipelines/resources_template.yml'
    config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'

    CreateFeatureBranchPipeline.createFrom(template, resources, config_file, ['branch1', 'branch2'])

    config_file = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(config_file['jobs'][0]['name']).to eq 'branch1-javascript-tests'
    expect(config_file['jobs'][1]['name']).to eq 'branch2-javascript-tests'
  end

  it 'should strip newlines' do
    template = Dir.pwd() + '/pipelines/feature-branch-pipeline.yml.erb'
    resources = Dir.pwd() + '/pipelines/resources_template.yml'
    config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'

    CreateFeatureBranchPipeline.createFrom(template, resources, config_file, ["branch1\n", "branch2\n"])

    config_file = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(config_file['jobs'][0]['name']).to eq 'branch1-javascript-tests'
  end

  it 'should include the resource information' do
    template = Dir.pwd() + '/pipelines/feature-branch-pipeline.yml.erb'
    resources = Dir.pwd() + '/pipelines/resources_template.yml'
    config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'

    CreateFeatureBranchPipeline.createFrom(template, resources, config_file, ['branch1', 'branch2'])

    config_file = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')

    expect(config_file['resources'][0]['name']).to eq 'pivotal-source'
  end
end