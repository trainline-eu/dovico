require "helper"

module Dovico
  describe Dovico::Employee do
    let(:employee_api_hash) do
      {
        "ID": "123",
        "FirstName": "James",
        "LastName": "Bond",
      }.stringify_keys
    end

    subject do
      Dovico::Employee.parse(employee_api_hash)
    end

    describe ".parse" do
      it "parses the hash" do
        employee = Dovico::Employee.parse(employee_api_hash)

        expect(employee).to be_an(Dovico::Employee)
        expect(employee.id).to eq('123')
        expect(employee.first_name).to eq('James')
        expect(employee.last_name).to eq('Bond')
      end
    end

    describe ".myself" do
      let(:employee_me_answer) do
        {
          "Employees": [ employee_api_hash ]
        }.stringify_keys
      end

      before do
        allow(ApiClient).to receive(:get).and_return(employee_me_answer)
      end

      it 'calls the API and return an Employee object' do
        myself = Dovico::Employee.myself

        expect(ApiClient).to have_received(:get).with("#{Dovico::Employee::URL_PATH}/Me")
        expect(myself).to be_an(Dovico::Employee)
        expect(myself.id).to eq('123')
      end
    end

    describe '#to_s' do
      it 'returns object with formatted text' do
        expect(subject.to_s).to eq(" - ID:         123\n - First Name: James\n - Last Name:  Bond")
      end
    end

    describe '.unserialize' do
      let(:employee_hash) do
        {
          id: "007",
          first_name: "James",
          last_name: "Bond",
        }
      end
      it 'returns new instance of the object' do
        employee = Employee.unserialize(employee_hash)

        expect(employee.id).to eq("007")
      end
    end
  end
end
