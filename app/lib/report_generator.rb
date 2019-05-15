require_relative './affiliate.rb'
require_relative './reseller.rb'
require_relative './direct_sale.rb'
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
    seller_report("amount_owed_to_manufacturer").to_json
  end

  def seller_profits
    seller_report("profit").to_json
  end

  def company_revenue
    {
      total_revenue: total_revenue,
      direct_sales_revenue: direct_sales_revenue,
      affiliates: affiliates_revenue_hash,
      resellers: resellers_revenue_hash
    }.to_json
  end

  private

  def seller_report(attribute_name)
    sellers.inject({}) do |report, seller|
      report[seller.name] = {
        attribute_name => seller.public_send(attribute_name)
      }
      report
    end
  end

  def total_revenue
    direct_sales_revenue + sellers_revenue
  end

  def direct_sales_revenue
    direct_sales * DirectSale::SALE_PRICE
  end

  def sellers_revenue
    affiliates_revenue + resellers_revenue
  end

  def affiliates_revenue
    sellers.inject(0.0) do |revenue, seller|
      revenue += seller.amount_owed_to_manufacturer if seller.is_a?(Affiliate)
      revenue
    end
  end

  def resellers_revenue
    sellers.inject(0.0) do |revenue, seller|
      revenue += seller.amount_owed_to_manufacturer if seller.is_a?(Reseller)
      revenue
    end
  end

  def affiliates_revenue_hash
    {
      total_revenue: affiliates_revenue,
      individual_revenues: individual_affiliates_revenues
    }
  end

  def resellers_revenue_hash
    {
      total_revenue: resellers_revenue,
      individual_revenues: individual_resellers_revenues
    }
  end

  def individual_affiliates_revenues
    sellers.inject([]) do |revenues, seller|
      revenues << {
        seller.name => seller.amount_owed_to_manufacturer
      } if seller.is_a?(Affiliate)
      revenues
    end
  end

  def individual_resellers_revenues
    sellers.inject([]) do |revenues, seller|
      revenues << {
        seller.name => seller.amount_owed_to_manufacturer
      } if seller.is_a?(Reseller)
      revenues
    end
  end
end
