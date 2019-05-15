require_relative './seller.rb'

class Affiliate < Seller
  LOW_TIER_RATE = 60.freeze
  MID_TIER_RATE = 50.freeze
  HIGH_TIER_RATE = 40.freeze

  def amount_owed_to_manufacturer
    (rate * widgets_sold).to_f
  end

  private

  def rate
    case widgets_sold
    when 0..500
      LOW_TIER_RATE
    when 501..1000
      MID_TIER_RATE
    else
      HIGH_TIER_RATE
    end
  end
end
