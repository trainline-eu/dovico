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
        "project_id": "1111",
        "task_id":    "111",
        "hours":      4,
      }.stringify_keys
    end
    let(:assignment_2) do
      {
        "project_id": "2222",
        "task_id":    "222",
        "hours":      3,
      }.stringify_keys
    end
    let(:assignment_3) do
      {
        "project_id": "3333",
        "task_id":    "333",
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
          expect(first_time_entry.project_id).to eq('1111')
          expect(first_time_entry.task_id).to eq('111')
          expect(first_time_entry.date).to eq('2017-01-02')
          expect(first_time_entry.start_time).to eq('0900')
          expect(first_time_entry.stop_time).to eq('1300')
          expect(first_time_entry.total_hours).to eq(4)

          expect(first_time_entry.employee_id).to eq(employee_id)
          expect(last_time_entry.project_id).to eq('2222')
          expect(last_time_entry.task_id).to eq('222')
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
            'special_days': {
              '2016-02-29': [],
              '2016-03-01': [ assignment_2 ],
            }.stringify_keys,
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

      context 'with specific day, weeks and month assignments' do
        let(:assignments_config) do
          {
            'default_day': [ ],
            'special_days': {
              '2017-08-28': [ assignment_1 ],
            }.stringify_keys,
            'special_weeks': {
              '2017-35': [ assignment_2 ],
            }.stringify_keys,
            'special_months': {
              '2017-09': [ assignment_3 ],
            }.stringify_keys,
          }.stringify_keys
        end
        context 'in the first week' do
          let(:start_date) { Date.parse('2017-08-28') }
          let(:end_date) { Date.parse('2017-08-29') }

          it 'uses specific days and weeks assignments' do
            time_entries = subject.generate(start_date, end_date)
            expect(time_entries.count).to eq(2)

            # Specific day
            expect(time_entries[0].date).to eq('2017-08-28')
            expect(time_entries[0].project_id).to eq('1111')
            expect(time_entries[0].task_id).to eq('111')

            # Specific week
            expect(time_entries[1].date).to eq('2017-08-29')
            expect(time_entries[1].project_id).to eq('2222')
            expect(time_entries[1].task_id).to eq('222')
          end
        end

        context 'in a second week' do
          let(:start_date) { Date.parse('2017-09-04') }
          let(:end_date) { Date.parse('2017-09-04') }

          it 'uses specific months assignments' do
            time_entries = subject.generate(start_date, end_date)

            # Specific month
            expect(time_entries[0].date).to eq('2017-09-04')
            expect(time_entries[0].project_id).to eq('3333')
            expect(time_entries[0].task_id).to eq('333')
          end
        end
      end
    end
  end
end
