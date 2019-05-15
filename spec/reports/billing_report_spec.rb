require 'spec_helper'
require 'json'
require_relative '../../app/lib/reports/billing_report.rb'

RSpec.describe BillingReport do
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

      it "returns report of bill amount for each seller" do
        expect(subject).to eq(
          {
            reseller.name => {
              amount_owed_to_manufacturer: reseller.amount_owed_to_manufacturer
            },
            affiliate.name => {
              amount_owed_to_manufacturer: affiliate.amount_owed_to_manufacturer
            }
          }.to_json
        )
      end
    end
  end
end
