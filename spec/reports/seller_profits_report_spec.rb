require 'spec_helper'
require 'json'
require_relative '../../app/lib/reports/seller_profits_report.rb'

RSpec.describe SellerProfitsReport do
  describe ".generate" do
    subject do
      described_class.generate(sellers: sellers)
    end

    context "sellers list is empty" do
      let(:sellers) { [] }

      it "returns an empty report" do
        expect(subject).to eq("{}")
      end
    end

    context "sellers list is not empty" do
      let(:reseller) { Reseller.new("a_reseller", 100.0) }
      let(:affiliate) { Affiliate.new("an_affiliate", 65.0) }
      let(:sellers) { [reseller, affiliate] }

      before do
        reseller.order_widgets(50)
        affiliate.order_widgets(75)
      end

      it "returns report of profit for each seller" do
        expect(subject).to eq(
          {
            reseller.name => {
              profit: reseller.profit
            },
            affiliate.name => {
              profit: affiliate.profit
            }
          }.to_json
        )
      end
    end
  end
end
