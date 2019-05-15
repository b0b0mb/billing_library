require 'spec_helper'
require_relative '../app/lib/affiliate.rb'

RSpec.describe Affiliate do
  subject do
    described_class.new(name, widget_price)
  end

  let(:name) { "test_reseller" }
  let(:widget_price) { 75.0 }
  let(:low_tier_rate) { Affiliate::LOW_TIER_RATE }
  let(:mid_tier_rate) { Affiliate::MID_TIER_RATE }
  let(:high_tier_rate) { Affiliate::HIGH_TIER_RATE }

  describe "amount_owed_to_manufacturer" do
    context "order quantity 0" do
      it "returns 0" do
        expect(subject.amount_owed_to_manufacturer).to eq(0)
      end
    end

    context "order quantity at top of low tier" do
      it "returns order quantity * low_tier_rate" do
        subject.order_widgets(500)
        expect(subject.amount_owed_to_manufacturer)
          .to eq(low_tier_rate * 500)
      end
    end

    context "order quantity at bottom of mid tier" do
      it "returns order quantity * mid_tier_rate" do
        subject.order_widgets(501)
        expect(subject.amount_owed_to_manufacturer)
          .to eq(mid_tier_rate * 501)
      end
    end

    context "order quantity at top of mid tier" do
      it "returns order quantity * mid_tier_rate" do
        subject.order_widgets(1000)
        expect(subject.amount_owed_to_manufacturer)
          .to eq(mid_tier_rate * 1000)
      end
    end

    context "order quantity in high tier" do
      it "returns order quantity * high_tier_rate" do
        subject.order_widgets(1001)
        expect(subject.amount_owed_to_manufacturer)
          .to eq(high_tier_rate * 1001)
      end
    end

    context "order quantity very high" do
      it "returns order quantity * high_tier_rate" do
        subject.order_widgets(100000)
        expect(subject.amount_owed_to_manufacturer)
          .to eq(high_tier_rate * 100000)
      end
    end
  end
end
