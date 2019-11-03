require "helper"

module Dovico
  describe Dovico::TimeEntryFormatter do
    let(:task_1) { Dovico::Task.new(id: "1", name: "TestTask 1") }
    let(:task_2) { Dovico::Task.new(id: "2", name: "TestTask 2") }
    let(:task_group) { Dovico::TaskGroup.new(assignments: [task_2]) }
    let(:project) { Dovico::Project.new(id: "42", name: "TestProject", assignments: [task_group, task_1]) }
    let(:myself) { Dovico::Employee.new(id: "99") }
    let(:assignments) { Dovico::Assignments.new }
    let(:time_entry_1) do
      Dovico::TimeEntry.new(
        project_id: "42",
        task_id: "1",
        start_time: "0900",
        stop_time: "1200",
        total_hours: "3",
        sheet_status: "U",
        date: "2018-01-01",
      )
    end
    let(:time_entry_2) do
      Dovico::TimeEntry.new(
        project_id: "42",
        task_id: "2",
        start_time: "1400",
        stop_time: "1800",
        total_hours: "4",
        sheet_status: "U",
        date: "2018-01-01",
      )
    end
    let(:time_entry_3) do
      Dovico::TimeEntry.new(
        project_id: "42",
        task_id: "1",
        start_time: "0900",
        stop_time: "1200",
        total_hours: "3",
        sheet_status: "U",
        date: "2018-01-02",
      )
    end
    let(:time_entries) { [time_entry_1, time_entry_2, time_entry_3] }

    before do
      allow(Assignment).to receive(:fetch_all).and_return([project])
      allow(Employee).to receive(:myself).and_return(myself)
    end

    subject do
      Dovico::TimeEntryFormatter.new(assignments)
    end

    describe "#format_entries" do
      it 'returns formatted tasks' do
        expect(subject.format_entries(time_entries)).to eq(
          "2018-01-01 [××××××        ] [under_review]  3h TestProject TestTask 1\n"+
          "2018-01-01 [      ××××××××] [under_review]  4h TestProject TestTask 2\n"+
          "2018-01-02 [××××××        ] [under_review]  3h TestProject TestTask 1"
        )
      end
    end
  end
end
