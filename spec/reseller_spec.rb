require 'spec_helper'
require_relative '../app/lib/reseller.rb'

RSpec.describe Reseller do
  subject do
    described_class.new(name, widget_price)
  end

  let(:name) { "test_reseller" }
  let(:widget_price) { 75.0 }
  let(:flat_rate) { Reseller::FLAT_RATE }

  describe "amount_owed_to_manufacturer" do
    it "returns flat_rate * total number of widgets ordered" do
      subject.order_widgets(25)
      expect(subject.amount_owed_to_manufacturer).to eq(flat_rate * 25)
    end
  end
end
