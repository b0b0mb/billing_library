require_relative './seller.rb'

class Reseller < Seller
  FLAT_RATE = 50.0.freeze

  def amount_owed_to_manufacturer
    (FLAT_RATE * widgets_sold).to_f
  end

  private

end
