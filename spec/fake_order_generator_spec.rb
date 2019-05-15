require 'spec_helper'
require_relative '../app/lib/fake_order_generator.rb'

RSpec.describe FakeOrderGenerator do
  subject do
    described_class.new
  end

  describe "#generated_orders" do
    it "returns list of 100 orders" do
      expect(subject.generated_orders.count).to eq 100
    end
  end

  describe "#affiliates" do
    it "returns list of 3 affiliates" do
      expect(subject.affiliates.count).to eq 3
    end
  end

  describe "#resellers" do
    it "returns list of 2 resellers" do
      expect(subject.resellers.count).to eq 2
    end
  end

  describe "#direct_sales_count" do
    it "returns a non nil value" do
      expect(subject.direct_sales_count).not_to be_nil
    end
  end

  describe "#sellers" do
    it "returns list of 5 sellers" do
      expect(subject.sellers.count).to eq 5
    end
  end
end
