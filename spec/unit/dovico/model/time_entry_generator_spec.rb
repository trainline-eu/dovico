require "helper"

module Dovico
  describe Dovico::TimeEntryGenerator do
    subject do
      Dovico::TimeEntryGenerator.new(
        employee_id: employee_id,
        assignments: assignments_config
      )
    end
    let(:employee_id) { "999" }
    let(:assignment_1) do
      {
        "project_id": "1234",
        "task_id":    "456",
        "hours":      4,
      }.stringify_keys
    end
    let(:assignment_2) do
      {
        "project_id": "6789",
        "task_id":    "999",
        "hours":      3,
      }.stringify_keys
    end
    let(:assignments_config) do
      {
        "default_day": [ assignment_1, assignment_2 ]
      }.stringify_keys
    end

    describe "#generate" do
      let(:start_date) { Date.parse('2017-01-02') }
      let(:end_date)   { Date.parse('2017-01-06') }

      context 'with minimal configuration' do
        it 'creates TimeEntries object for the date range' do
          time_entries = subject.generate(start_date, end_date)

          # 5 days * 2 time entries
          expect(time_entries.count).to eq(10)
          first_time_entry = time_entries.first
          last_time_entry = time_entries.last

          expect(first_time_entry.id).to be_nil
          expect(first_time_entry.employee_id).to eq(employee_id)
          expect(first_time_entry.project_id).to eq('1234')
          expect(first_time_entry.task_id).to eq('456')
          expect(first_time_entry.date).to eq('2017-01-02')
          expect(first_time_entry.start_time).to eq('0900')
          expect(first_time_entry.stop_time).to eq('1300')
          expect(first_time_entry.total_hours).to eq(4)

          expect(first_time_entry.employee_id).to eq(employee_id)
          expect(last_time_entry.project_id).to eq('6789')
          expect(last_time_entry.task_id).to eq('999')
          expect(last_time_entry.date).to eq('2017-01-06')
          expect(last_time_entry.start_time).to eq('1300')
          expect(last_time_entry.stop_time).to eq('1600')
          expect(last_time_entry.total_hours).to eq(3)
        end
      end

      context 'with specific day assignments' do
        let(:assignments_config) do
          {
            'default_day': [ assignment_1, assignment_2 ],
            '2016-02-29': [],
            '2016-03-01': [ assignment_2 ],
          }.stringify_keys
        end
        let(:start_date) { Date.parse('2016-02-29') }
        let(:end_date) { Date.parse('2016-03-01') }

        it 'uses specific day assignments' do
          time_entries = subject.generate(start_date, end_date)

          expect(time_entries.count).to eq(1)
          time_entry = time_entries.first
          expect(time_entry.date).to eq('2016-03-01')
          expect(time_entry.total_hours).to eq(3)
        end
      end
    end
  end
end
