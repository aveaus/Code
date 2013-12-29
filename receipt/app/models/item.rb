class Item < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :order

  attr_accessor :tax_total

  def item_total
    price * quantity
  end

  def is_exempt?
    is_exempt
  end

  def is_import?
    is_import
  end
end
