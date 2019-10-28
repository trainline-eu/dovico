require "helper"

module Dovico
  describe Dovico::ApiClient do
    let(:client_token) { "aaaaa-client-token-aaaaa" }
    let(:user_token) { "zzzzz-user-token-zzzzz" }
    let(:response_body) do
      {
        "Stubbed": "Response"
      }.to_json
    end

    before do
      Dovico::ApiClient.initialize!(client_token, user_token)
    end

    describe ".get" do
      context 'with a succcessful response' do
        it "passes the correct headers to the request and parses the JSON response" do
          stub_request(
            :get,
            "#{Dovico::ApiClient::API_URL}TimeEntries?filter=1234%205678&version=#{Dovico::ApiClient::API_VERSION}"
          )
            .with(
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': "WRAP access_token=\"client=#{client_token}&user_token=#{user_token}\"",
              }
            )
            .to_return(body: response_body)

          response = Dovico::ApiClient.get(
            'TimeEntries',
            params: {
              filter: '1234 5678'
            }
          )

          expect(response).to eq({"Stubbed": "Response"}.stringify_keys)
        end
      end

      context 'with a succcessful response' do
        it "raises an error if the API response is not 200 OK" do
          stub_request(:get, "#{Dovico::ApiClient::API_URL}TimeEntries?version=#{Dovico::ApiClient::API_VERSION}")
            .to_return(
              status: 503,
              body: response_body
            )

          expect { Dovico::ApiClient.get('TimeEntries') }.to raise_error 'Error during HTTP request'
        end
      end
    end

    describe ".post" do
      it 'posts the body with a POST request' do
        stub_request(:post,
          "#{Dovico::ApiClient::API_URL}TimeEntries?version=#{Dovico::ApiClient::API_VERSION}"
        )
          .with(
            body: '{"Fake":"Object"}',
          )
          .to_return(body: response_body)

        Dovico::ApiClient.post('TimeEntries', body: {"Fake": "Object"}.to_json)
      end
    end

    describe ".put" do
      it 'perform a PUT request' do
        stub_request(:put, "#{Dovico::ApiClient::API_URL}TimeEntries?version=#{Dovico::ApiClient::API_VERSION}")
          .to_return(body: response_body)

        response = Dovico::ApiClient.put('TimeEntries')
        expect(response).to eq({"Stubbed": "Response"}.stringify_keys)
      end
    end

    describe ".delete" do
      it 'perform a DELETE request' do
        stub_request(:delete, "#{Dovico::ApiClient::API_URL}TimeEntries/42?version=#{Dovico::ApiClient::API_VERSION}")
          .to_return(body: '')

        response = Dovico::ApiClient.delete('TimeEntries/42')
        expect(response).to eq(nil)
      end
    end

    describe ".get_paginated_list" do
      context 'with a non paginated result' do
        let(:response_body) do
          {
            "ExampleObjects": [
              { id: 1 },
              { id: 2 },
            ],
            "NextPageURI": "N/A"
          }.to_json
        end

        it "returns the objects" do
          stub_request(
            :get,
            "#{Dovico::ApiClient::API_URL}ExampleObjects?version=#{Dovico::ApiClient::API_VERSION}"
          ).to_return(body: response_body)

          response = Dovico::ApiClient.get_paginated_list('ExampleObjects', 'ExampleObjects')

          expect(response).to eq(
            {
              "ExampleObjects": [
                { id: 1 },
                { id: 2 },
              ]
            }.deep_stringify_keys
          )
        end
      end

      context 'with a paginated result' do
        let(:response_body_1) do
          {
            "ExampleObjects": [
              { id: 1 },
              { id: 2 },
            ],
            "NextPageURI": "#{Dovico::ApiClient::API_URL}ExampleObjects?next=1300&version=#{Dovico::ApiClient::API_VERSION}"
          }.to_json
        end
        let(:response_body_2) do
          {
            "ExampleObjects": [
              { id: 3 },
              { id: 4 },
            ],
            "NextPageURI": "N/A"
          }.to_json
        end

        it "queries the next page and return the objects concatened" do
          stub_request(:get, "#{Dovico::ApiClient::API_URL}ExampleObjects?version=#{Dovico::ApiClient::API_VERSION}")
            .to_return(body: response_body_1)
          stub_request(:get, "#{Dovico::ApiClient::API_URL}ExampleObjects?next=1300&version=#{Dovico::ApiClient::API_VERSION}")
            .to_return(body: response_body_2)

          response = Dovico::ApiClient.get_paginated_list('ExampleObjects', 'ExampleObjects')

          expect(response).to eq(
            {
              "ExampleObjects": [
                { id: 1 },
                { id: 2 },
                { id: 3 },
                { id: 4 },
              ]
            }.deep_stringify_keys
          )
        end
      end

    end
  end
end
