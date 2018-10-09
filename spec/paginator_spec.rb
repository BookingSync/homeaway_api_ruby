require "spec_helper"

RSpec.describe HomeAway::API::Paginator do
  describe "paginator" do
    subject(:paginator) { HomeAway::API::Paginator.new(client, hashie, params, auto_pagination) }
    let(:client) { client }
    let(:hashie) do
      Hashie::Mash.new(
        entries: [
          { "conversationUrl": "https://fake.com/conversation" },
        ],
        nextPage: "https://ws.homeaway.com/public/myInbox?page=2&pageSize=10",
        page: 1,
      )
    end
    let(:client) { double }
    let(:auto_pagination) { false }
    let(:opts) { {} }

    before do
      allow(HomeAway::API::Client).to receive(:new).with(opts).and_return(client)
    end

    context "when params given" do
      let(:params) do
        { "page" => 1, "pageSize" => 10, "afterDate" => "2018-09-08", "sort" => "RECEIVED", "sortOrder" => "DESC" }
      end

      it "iterates through pages using nextPage and given params" do
        expect(client)
          .to receive(:get)
          .with(
            "/public/myInbox",
            {
              "page"=>["2"],
              "pageSize"=>["10"],
              "afterDate"=>["2018-09-08"],
              "sort"=>["RECEIVED"],
              "sortOrder"=>["DESC"]
            }
          )

        paginator.next_page
      end
    end

    context "when no params given" do
      let(:params) { {} }

      it "iterates through pages using nextPage" do
        expect(client)
          .to receive(:get)
          .with("/public/myInbox", {"page"=>["2"], "pageSize"=>["10"]})

        paginator.next_page
      end
    end
  end
end
