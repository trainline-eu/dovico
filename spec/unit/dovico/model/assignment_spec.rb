require "helper"

module Dovico
  describe Dovico::Assignment do
    let(:assignment_api_hash) do
      {
        "ItemID":       "123",
        "AssignmentID": "T456",
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
        expect(assignment.assignement_id).to eq('T456')
        expect(assignment.name).to eq('Dovico API Client')
      end
    end
  end
end
