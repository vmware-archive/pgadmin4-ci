require 'rspec'
require 'feature_branch_pipeline_factory'

describe 'construct a feature branch pipeline' do

  before(:each) do
    template = Dir.pwd() + '/pipelines/feature-branch-pipeline-jobs.yml.erb'
    resources = Dir.pwd() + '/pipelines/feature-branch-pipeline-resources.yml.erb'
    @jobs_renderer = ERB.new File.read(template)
    @resources_renderer = ERB.new File.read(resources)

    @branches_list = ['branch1', 'branch2']

    initialize_pipeline_factory
  end

  it 'should output valid yaml' do
    generated_pipeline = @pipeline_factory.construct_pipeline_for_branches

    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
  end

  it 'should include multiple jobs' do
    generated_pipeline = @pipeline_factory.construct_pipeline_for_branches

    job_names = generated_pipeline['jobs'].map { |job| job['name'] }
    expect(job_names).to include 'branch1-javascript-tests'
    expect(job_names).to include 'branch2-javascript-tests'
    expect(job_names).to include 'branch1-python-tests-on-postgres-9.2'
    expect(job_names).to include 'branch2-python-tests-on-postgres-9.2'
  end

  it 'should include templated branches in resources' do
    generated_pipeline = @pipeline_factory.construct_pipeline_for_branches

    git_resources = generated_pipeline['resources'].select { |resource| resource['type'] == 'git' }
    git_branches = git_resources.map { |git_resource| git_resource['source']['branch'] }
    expect(git_branches).to include 'branch1'
    expect(git_branches).to include 'branch2'
  end

  it 'should not duplicate non-templated resources' do
    generated_pipeline = @pipeline_factory.construct_pipeline_for_branches

    resource_names = generated_pipeline['resources'].map { |resource| resource['name'] }
    expect(resource_names.count('placeholder-resource')).to eq 1
  end

  context 'when given no branches' do
    before(:each) do
      @branches_list = []

      initialize_pipeline_factory
    end

    it 'should generate no jobs' do
      generated_pipeline = @pipeline_factory.construct_pipeline_for_branches

      job_names = generated_pipeline['jobs'].map { |job| job['name'] }
      expect(job_names).to eq []
    end
  end

  def initialize_pipeline_factory
    @pipeline_factory = FeatureBranchPipelineFactory.new(@branches_list, @jobs_renderer, @resources_renderer)
  end
end



















