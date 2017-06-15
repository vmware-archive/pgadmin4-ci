require 'rspec'
require 'create_feature_branch_pipeline'

describe 'create' do

  before(:each) do
    @template = Dir.pwd() + '/pipelines/feature-branch-pipeline-jobs.yml.erb'
    @resources = Dir.pwd() + '/pipelines/feature-branch-pipeline-resources.yml.erb'
    @config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'
  end

  it 'should output valid yaml' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
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

  it 'should strip newlines' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ["branch1\n", "branch2\n"])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
  end

  it 'should include templated branches in resources' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1', 'branch2'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    git_resources = generated_pipeline['resources'].select { |resource| resource['type'] == 'git' }
    git_branches = git_resources.map { |git_resource| git_resource['source']['branch']}
    expect(git_branches).to include 'branch1'
    expect(git_branches).to include 'branch2'
  end

  it 'should not duplicate non-templated resources' do
    CreateFeatureBranchPipeline.createFrom(@template, @resources, @config_file, ['branch1', 'branch2'])

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    resource_names = generated_pipeline['resources'].map { |resource| resource['name'] }
    expect(resource_names.count('placeholder-resource')).to eq 1
  end
end