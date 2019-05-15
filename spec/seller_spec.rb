require 'spec_helper'
require_relative '../app/lib/seller.rb'

RSpec.describe Seller do
  subject do
    described_class.new(name, widget_price)
  end

  let(:name) { "test_seller" }
  let(:widget_price) { 75.0 }

  describe "name" do
    it "returns the name it was initialized with" do
      expect(subject.name).to eq(name)
    end
  end

  describe "order_widgets" do
    it "increases total widgets sold by the quantity ordered" do
      subject.order_widgets(50)
      expect(subject.widgets_sold).to eq 50
      subject.order_widgets(25)
      expect(subject.widgets_sold).to eq 75
    end
  end

  describe "profit" do
    # method must be implemented in subclass
    it "raises an error" do
      expect {subject.profit}.to raise_error(Seller::MethodNotImplemented)
    end
  end

  describe "amount_owed_to_manufacturer" do
    # method must be implemented in subclass
    it "raises an error" do
      expect {subject.amount_owed_to_manufacturer}.to raise_error(Seller::MethodNotImplemented)
    end
  end
end
