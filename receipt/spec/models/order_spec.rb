require 'spec_helper'

describe Order do
  before do
    @order = Order.make
  end

  it "should create a valid Order" do
    @order.tax_total.should == 0
    @order.item_total.should == 0

    @order.sales_tax_rate.should == 0.1
    @order.import_tax_rate.should == 0.05
  end

  it "should round a cost to the nearest nickle" do
    @order.round_to_nearest_nickle(1.50).should == 1.50
    @order.round_to_nearest_nickle(1.51).should == 1.55
    @order.round_to_nearest_nickle(1.54).should == 1.55
    @order.round_to_nearest_nickle(1.56).should == 1.56
    @order.round_to_nearest_nickle(1.59).should == 1.59
  end

  describe "Ordering items" do
    before do
      @item1 = Item.make(:price => 3.46, :quantity => 2, :is_exempt => true)
      @item2 = Item.make(:price => 6.99, :quantity => 1)
      @item3 = Item.make(:price => 2.37, :quantity => 3)
    end

    it "should calculate the tax and item for exempt item" do
      @order.items << @item1
      @order.save!
    end
  end
end
