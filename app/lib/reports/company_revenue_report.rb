require_relative '../affiliate.rb'
require_relative '../reseller.rb'
require_relative '../direct_sale.rb'

class CompanyRevenueReport
  class << self
    def generate(sellers: [], direct_sales: 0)
      new(sellers: sellers, direct_sales: direct_sales).generate
    end
  end

  def initialize(sellers: [], direct_sales: 0)
    @sellers = sellers
    @direct_sales = direct_sales
  end

  attr_reader :sellers, :direct_sales

  def generate
    {
      total_revenue: total_revenue,
      direct_sales_revenue: direct_sales_revenue,
      affiliates: affiliates_revenue_hash,
      resellers: resellers_revenue_hash
    }.to_json
  end

  private

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
