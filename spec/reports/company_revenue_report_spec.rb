require 'spec_helper'
require 'json'
require_relative '../../app/lib/reports/company_revenue_report.rb'

RSpec.describe CompanyRevenueReport do
  subject do
    described_class.generate(
      sellers: sellers,
      direct_sales: direct_sales
    )
  end

  let(:reseller) { Reseller.new("a_reseller", 100.0) }
  let(:affiliate) { Affiliate.new("an_affiliate", 65.0) }
  let(:reseller_2) { Reseller.new("another_reseller", 75.0) }
  let(:affiliate_2) { Affiliate.new("another_affiliate", 50.0) }

  before do
    reseller.order_widgets(50)
    affiliate.order_widgets(75)
    reseller_2.order_widgets(400)
    affiliate_2.order_widgets(600)
  end

  context "no sales" do
    let(:sellers) { [] }
    let(:direct_sales) { 0 }

    it "returns report with 0 revenue" do
      expect(subject).to eq(
        {
          total_revenue: 0.0,
          direct_sales_revenue: 0.0,
          affiliates: {
            total_revenue: 0.0,
            individual_revenues: []
          },
          resellers: {
            total_revenue: 0.0,
            individual_revenues: []
          }
        }.to_json
      )
    end
  end

  context "direct sales only" do
    let(:sellers) { [] }
    let(:direct_sales) { 1000 }

    it "returns report with direct sales revenue" do
      expect(subject).to eq(
        {
          total_revenue: 100000.0,
          direct_sales_revenue: 100000.0,
          affiliates: {
            total_revenue: 0.0,
            individual_revenues: []
          },
          resellers: {
            total_revenue: 0.0,
            individual_revenues: []
          }
        }.to_json
      )
    end
  end

  context "sales from sellers only" do
    let(:sellers) { [affiliate, reseller, affiliate_2, reseller_2] }
    let(:direct_sales) { 0 }

    it "returns report with sellers revenue" do
      expect(subject).to eq(
        {
          total_revenue: 57000.0,
          direct_sales_revenue: 0.0,
          affiliates: {
            total_revenue: 34500.0,
            individual_revenues: [
              {affiliate.name => affiliate.amount_owed_to_manufacturer},
              {affiliate_2.name => affiliate_2.amount_owed_to_manufacturer}
            ]
          },
          resellers: {
            total_revenue: 22500.0,
            individual_revenues: [
              {reseller.name => reseller.amount_owed_to_manufacturer},
              {reseller_2.name => reseller_2.amount_owed_to_manufacturer}
            ]
          }
        }.to_json
      )
    end
  end

  context "sales from sellers and direct sales" do
    let(:sellers) { [affiliate, reseller, affiliate_2, reseller_2] }
    let(:direct_sales) { 1000 }

    it "returns report with sellers revenue and direct sales revenue" do
      expect(subject).to eq(
        {
          total_revenue: 157000.0,
          direct_sales_revenue: 100000.0,
          affiliates: {
            total_revenue: 34500.0,
            individual_revenues: [
              {affiliate.name => affiliate.amount_owed_to_manufacturer},
              {affiliate_2.name => affiliate_2.amount_owed_to_manufacturer}
            ]
          },
          resellers: {
            total_revenue: 22500.0,
            individual_revenues: [
              {reseller.name => reseller.amount_owed_to_manufacturer},
              {reseller_2.name => reseller_2.amount_owed_to_manufacturer}
            ]
          }
        }.to_json
      )
    end
  end
end
