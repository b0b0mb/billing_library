require_relative '../affiliate.rb'
require_relative '../reseller.rb'

class SellerProfitsReport
  class << self
    def generate(sellers: [])
      new(sellers: sellers).generate
    end
  end

  def initialize(sellers: [])
    @sellers = sellers
  end

  attr_reader :sellers

  def generate
    build_report.to_json
  end

  private

  def build_report
    sellers.inject({}) do |report, seller|
      report[seller.name] = {
        profit: seller.profit
      }
      report
    end
  end
end
