require 'rspec'
require 'create_feature_branch_pipeline'

describe 'create' do

  before(:each) do
    @template = Dir.pwd() + '/pipelines/feature-branch-pipeline.yml.erb'
    @resources = Dir.pwd() + '/pipelines/resources_template.yml.erb'
    @config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'
  end

  it 'should output valid yaml' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1', 'branch2'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
  end

  it 'should strip newlines' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ["branch1\n", "branch2\n"])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(generated_pipeline['jobs'][0]['name']).to eq 'branch1-javascript-tests'
  end

  it 'should include multiple jobs' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1', 'branch2'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
    expect(job_names).to include 'branch2-javascript-tests'
    expect(job_names).to include 'branch1-python-tests'
    expect(job_names).to include 'branch2-python-tests'
  end

  it 'should include the resource information' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1', 'branch2'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    expect(generated_pipeline['resources'][0]['name']).to eq 'pivotal-source'
  end
end