require_relative './reports/billing_report.rb'
require_relative './reports/seller_profits_report.rb'
require_relative './reports/company_revenue_report.rb'
require 'json'

class ReportGenerator
  class << self
    def billing(sellers: [])
      new(sellers: sellers, direct_sales: 0).billing
    end

    def seller_profits(sellers: [])
      new(sellers: sellers, direct_sales: 0).seller_profits
    end

    def company_revenue(sellers: [], direct_sales: 0)
      new(sellers: sellers, direct_sales: direct_sales).company_revenue
    end
  end

  def initialize(sellers: [], direct_sales: 0)
    @sellers = sellers
    @direct_sales = direct_sales
  end

  attr_reader :sellers, :direct_sales

  def billing
    BillingReport.generate(sellers: sellers)
  end

  def seller_profits
    SellerProfitsReport.generate(sellers: sellers)
  end

  def company_revenue
    CompanyRevenueReport.generate(sellers: sellers, direct_sales: direct_sales)
  end
end
