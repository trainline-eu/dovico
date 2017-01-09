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
  end
end
