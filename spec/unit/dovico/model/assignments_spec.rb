require "helper"

module Dovico
  describe Dovico::Assignments do
    let(:task_1) { Dovico::Task.new(name: "T789", id: "789") }
    let(:task_group) { Dovico::TaskGroup.new(name: "TG555", id: "555", assignments: [task_1]) }
    let(:project_1) { Dovico::Project.new(id: "123", name: "P1", assignments: [task_1]) }
    let(:project_2) { Dovico::Project.new(id: "456", name: "P2", assignments: [task_group]) }
    let(:assignments) { Dovico::Assignments.new }
    let(:myself) { Dovico::Employee.new(id: "99") }
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
              "id"                  => "987",
              "assignement_id"      => "T987",
              "name"                => "Example Task Name",
              "start_date"          => "N/A",
              "finish_date"         => "N/A",
              "assignments"         => [],
              "get_assignments_uri" => "https://api.dovico.com/Assignments/T987/?version=5"
            },
          ]
        }
      ]
    end

    before do
      allow(Dovico::Assignment).to receive(:fetch_all).and_return([project_1, project_2])
      allow(Dovico::Employee).to receive(:myself).and_return(myself)
    end

    describe ".new" do
      before do
        allow(Dovico::Assignment).to receive(:fetch_all).and_return([project_1, project_2])
      end

      context "when the cache file is valid" do
        it 'loads from the cache' do
          write_cache_file(Dovico::Assignments::CACHE_VERSION, assignments_json_hash)

          assignments = Dovico::Assignments.new
          expect(assignments.assignments.count).to eq(1)
          expect(assignments.assignments.first.id).to eq("123")

          expect(Dovico::Assignment).not_to have_received(:fetch_all)
        end
      end

      context "when force_refresh is true" do
        it 'fetches the assignments from the API' do
          write_cache_file(Dovico::Assignments::CACHE_VERSION, assignments_json_hash)

          assignments = Dovico::Assignments.new(force_refresh: true)
          expect(assignments.assignments.count).to eq(2)

          expect(Dovico::Assignment).to have_received(:fetch_all)
        end
      end

      context 'when no cache exists' do
        it 'fetches the assignments from the API and saves the cache' do
          assignments = Dovico::Assignments.new
          expect(assignments.assignments.count).to eq(2)

          expect(Dovico::Assignment).to have_received(:fetch_all)

          cache_content = File.read(Dovico::Assignments::CACHE_FILE)
          cache_saved = JSON.parse(cache_content)
          expect(cache_saved["version"]).to eq(Dovico::Assignments::CACHE_VERSION)
          expect(cache_saved["assignments"].count).to eq(2)
          expect(cache_saved["assignments"].first["id"]).to eq("123")
        end
      end

      context 'when the cache file is not JSON valid' do
        it 'fetches the assignments from the API' do
          File.write(Dovico::Assignments::CACHE_FILE, "err-not-json")

          assignments = Dovico::Assignments.new
          expect(assignments.assignments.count).to eq(2)

          expect(Dovico::Assignment).to have_received(:fetch_all)
        end
      end

      context 'when the cache version does not match' do
        it 'fetches the assignments from the API' do
          write_cache_file("test-version", assignments_json_hash)

          assignments = Dovico::Assignments.new
          expect(assignments.assignments.count).to eq(2)

          expect(Dovico::Assignment).to have_received(:fetch_all)
        end
      end
    end

    describe ".format_tree" do
      it 'returns assignments formatted' do
        expect(assignments.format_tree).to eq(
          "Project #123 P1\n"+
          "  Task #789 T789\n"+
          "\n"+
          "Project #456 P2\n"+
          "  TaskGroup #555 TG555\n"+
          "    Task #789 T789\n\n"
)
      end
    end

    describe ".find_project_task" do
      context 'when a task matches' do
        it 'returns project and task id' do
          project, task = assignments.find_project_task(project_1.id, task_1.id)
          expect(project).to eq(project_1)
          expect(task).to eq(task_1)

          project, task = assignments.find_project_task(project_2.id, task_1.id)
          expect(project).to eq(project_2)
          expect(task).to eq(task_1)
        end

      end

      context 'when no tasks match' do
        it 'raises an error' do
          expect do
            assignments.find_project_task(project_1.id, "99999")
          end.to raise_error("Can't find project#123/task#99999. Try with --force-refresh option")
        end

      end
    end

    def write_cache_file(version, assignments)
      cache = {
        version: version,
        assignments: assignments,
      }
      File.write(Dovico::Assignments::CACHE_FILE, cache.to_json)
    end
  end
end
