require "helper"

module Dovico
  describe Dovico::Client do
    let(:client_api_hash) do
      {
        "ItemID":       "123",
        "AssignmentID": "C123",
        "Name":         "Dovico API Client",
        "StartDate":    "2017-01-01",
        "FinishDate":   "2017-12-31",
      }.stringify_keys
    end

    describe ".parse" do
      it "parses the API hash" do
        client = Dovico::Task.parse(client_api_hash)

        expect(client).to be_an(Dovico::Client)
        expect(client.id).to eq('123')
        expect(client.assignement_id).to eq('C123')
        expect(client.name).to eq('Dovico API Client')
      end
    end
  end
end
