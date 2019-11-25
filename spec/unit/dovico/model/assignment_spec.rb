require "helper"

module Dovico
  describe Dovico::Assignment do
    let(:assignment_api_hash) do
      {
        "ItemID":       "123",
        "AssignmentID": "T123",
        "Name":         "Dovico API Client",
        "StartDate":    "2017-01-01",
        "FinishDate":   "2017-12-31",
      }.stringify_keys
    end

    describe ".parse" do
      it "parses the API hash" do
        assignment = Dovico::Assignment.parse(assignment_api_hash)

        expect(assignment).to be_an(Dovico::Assignment)
        expect(assignment.id).to eq('123')
        expect(assignment.assignement_id).to eq('T123')
        expect(assignment.name).to eq('Dovico API Client')
      end
    end

    describe ".unserialize" do
      let(:assignments_json_hash) do
        [
          {
            "id"                  => "123",
            "assignement_id"      => "P123",
            "name"                => "Example Project Name",
            "start_date"          => "2017-01-01",
            "finish_date"         => "2017-12-31",
            "get_assignments_uri" => "https://api.dovico.com/Assignments/P123/?version=5",
            "assignments"         => [
              {
                "id"                  => "520",
                "assignement_id"      => "G520",
                "name"                => "Example TaskGroup Name",
                "start_date"          => "N/A",
                "finish_date"         => "N/A",
                "assignments"         => [],
                "get_assignments_uri" => "https://api.dovico.com/Assignments/T987/?version=5"
              },
              {
                "id"                  => "888",
                "assignement_id"      => "C888",
                "name"                => "Example Client Name",
                "start_date"          => "N/A",
                "finish_date"         => "N/A",
                "assignments"         => [],
                "get_assignments_uri" => "https://api.dovico.com/Assignments/C888/?version=5"
              },
              {
                "id"                  => "987",
                "assignement_id"      => "T987",
                "name"                => "Example Task Name",
                "start_date"          => "N/A",
                "finish_date"         => "N/A",
                "assignments"         => [],
                "get_assignments_uri" => "https://api.dovico.com/Assignments/T987/?version=5"
              },
            ],
          }
        ]
      end

      it "unserializes a hash to an object" do
        assignments = Dovico::Assignment.unserialize(assignments_json_hash)

        expect(assignments.count).to eq(1)
        project = assignments.first
        expect(project).to be_an(Dovico::Project)
        expect(project.id).to eq('123')
        expect(project.assignement_id).to eq('P123')
        expect(project.name).to eq('Example Project Name')

        expect(project.assignments.count).to eq(3)

        group_task = project.assignments[0]
        expect(group_task).to be_an(Dovico::TaskGroup)
        expect(group_task.id).to eq('520')

        client = project.assignments[1]
        expect(client).to be_an(Dovico::Client)
        expect(client.id).to eq('888')

        task = project.assignments[2]
        expect(task).to be_an(Dovico::Task)
        expect(task.id).to eq('987')
      end

      it "raises if the type is unknown" do
        expect do
          Dovico::Assignment.unserialize([{ "assignement_id" => "X456" }])
        end.to raise_error("AssignmentID X unsupported")
      end
    end

    describe ".fetch_all" do
      let(:project_api_hash) do
        {
          "ItemID":            "123",
          "AssignmentID":      "P123",
          "Name":              "Project Dovico API Client",
          "StartDate":         "2017-01-01",
          "FinishDate":        "2017-12-31",
          "GetAssignmentsURI": "https://dovico.example/Assignments/T456?version=5"
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
          "AssignmentID": "T995",
          "Name":         "Task write specs, second part",
        }.stringify_keys
      end
      let(:task_api_hash_2) do
        {
          "ItemID":       "789",
          "AssignmentID": "T789",
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

      before do
        allow(ApiClient).to receive(:get_paginated_list).with(Dovico::Assignment::URL_PATH, "Assignments").and_return(projects_api_hash)
        allow(ApiClient).to receive(:get_paginated_list).with("https://dovico.example/Assignments/T456?version=5", "Assignments").and_return(tasks_api_hash)
      end

      it "fetches recursively all the assignements" do
        projects = Dovico::Assignment.fetch_all

        expect(projects.count).to eq(1)
        project = projects.first
        expect(project).to be_an(Dovico::Project)
        expect(project.id).to eq('123')
        expect(project.name).to eq('Project Dovico API Client')

        expect(project.assignments.count).to eq(2)
        task = project.assignments.first
        expect(task.id).to eq('789')
        expect(task.name).to eq('Task write specs')
      end
    end

    describe "#find_object" do
      let(:task)       { Dovico::Task.new(id: "789") }
      let(:task_group) { Dovico::TaskGroup.new(id: "456", assignments: [ task ]) }
      let(:project)    { Dovico::Project.new(id: "123", assignments: [ task_group ]) }

      context "when object is self" do
        it 'returns itself' do
          expect(project.find_object(Project, "123")).to eq(project)
        end
      end

      context "when object is its assignments" do
        it 'searches recursively' do
          expect(project.find_object(TaskGroup, "456")).to eq(task_group)
          expect(project.find_object(Task, "789")).to eq(task)
        end
      end
    end

    describe "#to_s" do
      let(:task)       { Dovico::Task.new(id: "789", name: "BigProject") }
      let(:task_group) { Dovico::TaskGroup.new(id: "456", name: "MiddleGroup", assignments: [ task ]) }
      let(:project)    { Dovico::Project.new(id: "123", name: "SmallTask", assignments: [ task_group ]) }

      it 'returns a string representation' do
        expect(project.to_s).to eq(
          "Project #123 SmallTask\n"+
          "  TaskGroup #456 MiddleGroup\n"+
          "    Task #789 BigProject\n"+
          "\n"
          )
      end
    end
  end
end
