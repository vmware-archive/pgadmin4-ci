require 'rspec'
require 'create_feature_branch_pipeline'

describe 'create' do

  it 'should output valid yaml' do
    CreateFeatureBranchPipeline.create(['branch1', 'branch2'])

    config_file = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(config_file['jobs'][0]['name']).to eq 'branch1-javascript-tests'
    expect(config_file['jobs'][1]['name']).to eq 'branch2-javascript-tests'
  end

  it ('should strip newlines') do
    CreateFeatureBranchPipeline.create(["branch1\n", "branch2\n"])

    config_file = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(config_file['jobs'][0]['name']).to eq 'branch1-javascript-tests'
  end
end