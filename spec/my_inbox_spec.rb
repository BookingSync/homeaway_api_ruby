# Copyright (c) 2015 HomeAway.com, Inc.
# All rights reserved.  http://www.homeaway.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'my inbox' do

  describe "with cassette", :vcr do
    before :each do
      @client = authd_client
    end

    it 'can get my inbox' do
      expect {
        expect(@client.my_inbox).to be_an_instance_of HomeAway::API::Paginator
      }.to_not raise_error
    end

    it 'can get my inbox as a traveler' do
      expect {
        expect(@client.my_inbox :as_traveler => true).to be_an_instance_of HomeAway::API::Paginator
      }.to_not raise_error
    end
  end

  context "with stub" do
    let(:client) { HomeAway::API::Client.new(client_id: client_id, client_secret: client_secret) }
    let(:response) do
      Hashie::Mash.new(
        entries: [
          { "conversationUrl": "https://fake.com/conversation_1" }
        ],
        nextPage: "https://ws.homeaway.com/public/myInbox?page=2&pageSize=10",
        page: 1,
      )
    end
    let(:params) do
      {
        "page" => 1,
        "pageSize" => 10,
        "asTraveler" => false,
        "afterDate" => "2018-09-08",
        "sort" => "RECEIVED",
        "sortOrder" => "DESC"
      }
    end

    before do
      allow(client).to receive(:get).with('/public/myInbox', params).and_return(response)
      allow(client).to receive(:my_inbox).and_call_original
    end

    it "constucts paginator with response and params" do
      expect(HomeAway::API::Paginator).to receive(:new).with(client, response, true, params)

      client.my_inbox(after_date: "2018-09-08", sort: "RECEIVED", sort_order: "DESC")
    end
  end
end
