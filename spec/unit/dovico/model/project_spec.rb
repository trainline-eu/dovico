require "helper"

module Dovico
  describe Dovico::Project do
    subject do
      Dovico::Project.parse(project_api_hash)
    end

    let(:project_api_hash) do
      {
        "ItemID":       "123",
        "AssignmentID": "T456",
        "Name":         "Project Dovico API Client",
        "StartDate":    "2017-01-01",
        "FinishDate":   "2017-12-31",
      }.stringify_keys
    end
    let(:projects_api_hash) do
      {
        "Assignments": [project_api_hash]
      }.stringify_keys
    end
    let(:task_api_hash_1) do
      {
        "ItemID":       "995",
        "AssignmentID": "E456",
        "Name":         "Task write specs, second part",
      }.stringify_keys
    end
    let(:task_api_hash_2) do
      {
        "ItemID":       "789",
        "AssignmentID": "E456",
        "Name":         "Task write specs",
        "StartDate":    "2016-10-25",
        "FinishDate":   "2018-05-01",
      }.stringify_keys
    end
    let(:tasks_api_hash) do
      {
        "Assignments": [task_api_hash_1, task_api_hash_2]
      }.stringify_keys
    end

    describe ".all" do
      before do
        allow(ApiClient).to receive(:get_paginated_list).with(Dovico::Project::URL_PATH, "Assignments").and_return(projects_api_hash)
        allow(ApiClient).to receive(:get_paginated_list).with("#{Dovico::Project::URL_PATH}/T456", "Assignments").and_return(tasks_api_hash)
      end

      it "lists all the assignements" do
        projects = Dovico::Project.all

        expect(projects.count).to eq(1)
        project = projects.first
        expect(project).to be_an(Dovico::Project)
        expect(project.id).to eq('123')
        expect(project.name).to eq('Project Dovico API Client')

        expect(project.tasks.count).to eq(2)
        task = project.tasks.first
        expect(task.id).to eq('789')
        expect(task.name).to eq('Task write specs')
      end
    end

    describe ".format_all" do
      before do
        allow(ApiClient).to receive(:get_paginated_list).with(Dovico::Project::URL_PATH, "Assignments").and_return(projects_api_hash)
        allow(ApiClient).to receive(:get_paginated_list).with("#{Dovico::Project::URL_PATH}/T456", "Assignments").and_return(tasks_api_hash)
      end

      it 'returns projects with formatted text' do
        expected_strings = [
          ' Project | Task | Description',
          '     123 |  789 | Project Dovico API Client: Task write specs',
          '     123 |  995 | Project Dovico API Client: Task write specs, second part',
        ]
        expect(Dovico::Project.format_all).to eq(expected_strings.join("\n"))
      end
    end

    describe '#to_s' do
      it 'returns object with formatted text' do
        expect(subject.to_s).to eq("     123 |      | Project Dovico API Client (No tasks linked)")
      end
    end
  end
end
