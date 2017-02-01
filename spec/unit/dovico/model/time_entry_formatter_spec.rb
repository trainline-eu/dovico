require "helper"

module Dovico
  describe Dovico::TimeEntryFormatter do
    let(:task) { Dovico::Task.new(id: "1212", name: "TestTask") }
    let(:project) { Dovico::Project.new(id: "9898", name: "TestProject", tasks: [task]) }
    let(:time_entry) do
      Dovico::TimeEntry.new(
        project_id: "9898",
        task_id: "1212",
        start_time: "0900",
        stop_time: "1200",
        total_hours: "3",
        sheet_status: "U"
      )
    end

    subject do
      Dovico::TimeEntryFormatter.new([project])
    end

    describe "#format_entries" do
      it 'returns formatted tasks' do
        expect(subject.format_entries([time_entry])).to eq(' [××××××]            : [under_review]  3h TestProject TestTask')
      end
    end
  end
end
