class Order < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :items

  def tax_cost_total
    tax_total = 0

    # calculate sales and import tax for each items in the order
    items.each_with_index{ |item, i|
      sales_tax = item.is_exempt? ? 0 : item.item_total * sales_tax_rate
      import_tax = item.is_import? ? item.item_total * import_tax_rate : 0

      # save the tax total
      items[i].tax_total = round_to_nearest_nickle(sales_tax + import_tax)

      total += items[i].tax_total
    }

    tax_total
  end

  def base_cost_total
    item_total = 0
    items.each { |item|
      item_total += item.item_total
    }
    item_total
  end

  def price_total
    base_cost_total + tax_cost_total
  end

  # round up the price to the nearest 0.05:
  # $1.52 => $1.55, $1.56 => $1.56
  def round_to_nearest_nickle(cost)
    # round to the hundreds decimal first
    cost = cost.round(2)

    # round up if the hundredth decimal is less than 0.05
    decimal = (cost % 1) * 100
    hundredth = decimal % 10
    if hundredth < 5 && hundredth > 0
      hundredth_diff = (5.0 - hundredth) / 100
      cost += hundredth_diff
    end

    cost
  end
end
