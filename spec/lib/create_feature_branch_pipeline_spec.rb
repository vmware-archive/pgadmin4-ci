require 'rspec'
require 'feature_branch_pipeline_creator'

describe 'Create a feature branch pipeline' do

  before(:each) do
    @template = Dir.pwd() + '/pipelines/feature-branch-pipeline-jobs.yml.erb'
    @resources = Dir.pwd() + '/pipelines/feature-branch-pipeline-resources.yml.erb'
    @config_file = Dir.pwd() + '/pipelines/generated-feature-branch-pipeline.yml'
  end

  it 'should accept and include header string' do
    pipeline_creator = FeatureBranchPipelineCreator.new(['branch1'], '#Look a generated-file warning', @template, @resources, @config_file)
    pipeline_creator.create

    generated_content = File.read('pipelines/generated-feature-branch-pipeline.yml')
    expect(generated_content).to start_with '#Look a generated-file warning'
  end

  it 'should strip newlines' do
    pipeline_creator = FeatureBranchPipelineCreator.new(["branch1\n", "branch2\n"], '', @template, @resources, @config_file)
    pipeline_creator.create

    generated_pipeline = YAML.load_file('pipelines/generated-feature-branch-pipeline.yml')
    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
  end
end