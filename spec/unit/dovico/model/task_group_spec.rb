require "helper"

module Dovico
  describe Dovico::TaskGroup do
    let(:task_group_api_hash) do
      {
        "ItemID":       "123",
        "AssignmentID": "G123",
        "Name":         "Dovico API Client",
        "StartDate":    "2017-01-01",
        "FinishDate":   "2017-12-31",
      }.stringify_keys
    end

    describe ".parse" do
      it "parses the API hash" do
        task = Dovico::TaskGroup.parse(task_group_api_hash)

        expect(task).to be_an(Dovico::TaskGroup)
        expect(task.id).to eq('123')
        expect(task.assignement_id).to eq('G123')
        expect(task.name).to eq('Dovico API Client')
      end
    end
  end
end
