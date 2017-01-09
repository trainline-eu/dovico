require "helper"

module Dovico
  describe Dovico::TimeEntry do
    subject do
      Dovico::TimeEntry.parse(time_entry_api_hash)
    end
    let(:project_hash) do
      {
        "ID": "111"
      }.stringify_keys
    end
    let(:task_hash) do
      {
        "ID": "222"
      }.stringify_keys
    end
    let(:employee_hash) do
      {
        "ID": "333"
      }.stringify_keys
    end
    let(:time_entry_api_hash) do
      {
        "ID":         "456",
        "StartTime":  "0800",
        "StopTime":   "1100",
        "Project":    project_hash,
        "Task":       task_hash,
        "Employee":   employee_hash,
        "Date":       "2017-01-05",
        "TotalHours": "3",
        "Description": "Unit test",
      }.stringify_keys
    end

    describe ".parse" do
      it "parses the API hash" do
        time_entry = Dovico::TimeEntry.parse(time_entry_api_hash)

        expect(time_entry).to be_an(Dovico::TimeEntry)
        expect(time_entry.start_time).to eq('0800')
        expect(time_entry.project_id).to eq('111')
        expect(time_entry.employee_id).to eq('333')
        expect(time_entry.total_hours).to eq('3')
      end

      context 'with a GUID ID' do
        it 'removes the first character of the GUID' do
          time_entry = Dovico::TimeEntry.parse(
            time_entry_api_hash.merge(
              {"ID": "T0bb4860f-2669-49ab-ae5e-dd8908366c8b"}.stringify_keys
            )
          )

          expect(time_entry.id).to eq('0bb4860f-2669-49ab-ae5e-dd8908366c8b')
        end
      end
    end

    describe ".get" do
      let(:time_entry_list_api) do
        {
          "TimeEntries": [ time_entry_api_hash ]
        }.stringify_keys
      end

      before do
        allow(ApiClient).to receive(:get).and_return(time_entry_list_api)
      end

      it 'calls the API and return an TimeEntry object' do
        time_entry = Dovico::TimeEntry.get('999')

        expect(ApiClient).to have_received(:get).with("#{Dovico::TimeEntry::URL_PATH}/999")
        expect(time_entry).to be_an(Dovico::TimeEntry)
        expect(time_entry.id).to eq('456')
      end
    end

    describe ".batch_create!" do
      let(:assignments) do
        [ subject ]
      end

      before do
        allow(ApiClient).to receive(:post)
      end

      it 'calls the API and post TimeEntries objects' do
        Dovico::TimeEntry.batch_create!(assignments)

        expect(ApiClient).to have_received(:post).with(
          "#{Dovico::TimeEntry::URL_PATH}",
          body: [subject.to_api].to_json
        )
      end
    end

    describe ".submit!" do
      let(:start_date) { Date.parse("2017-01-02") }
      let(:end_date) { Date.parse("2017-01-12") }
      let(:employee_id) { "333" }

      before do
        allow(ApiClient).to receive(:post)
      end

      it 'calls the API and submit a time range' do
        Dovico::TimeEntry.submit!(employee_id, start_date, end_date)

        expect(ApiClient).to have_received(:post).with(
          "#{Dovico::TimeEntry::URL_PATH}/Employee/#{employee_id}/Submit",
          params: {
            daterange: "2017-01-02 2017-01-12"
          },
          body: {}.to_json
        )
      end
    end

    describe ".create!" do
      before do
        allow(ApiClient).to receive(:post)
      end

      it 'calls the API and post TimeEntries objects' do
        subject.create!

        expect(ApiClient).to have_received(:post).with(
          "#{Dovico::TimeEntry::URL_PATH}",
          body: [subject.to_api].to_json
        )
      end
    end

    describe ".update!" do
      before do
        allow(ApiClient).to receive(:put)
      end

      it 'calls the API and post TimeEntries objects' do
        subject.update!

        expect(ApiClient).to have_received(:put).with(
          "#{Dovico::TimeEntry::URL_PATH}",
          body: [subject.to_api].to_json
        )
      end
    end

    describe ".to_api" do
      it 'serializes the object' do
        expect(subject.to_api).to eq(
          "ID"          => "456",
          "EmployeeID"  => "333",
          "ProjectID"   => "111",
          "TaskID"      => "222",
          "Date"        => "2017-01-05",
          "StartTime"   => "0800",
          "StopTime"    => "1100",
          "TotalHours"  => "3",
          "Description" => "Unit test",
        )
      end
    end
  end
end
