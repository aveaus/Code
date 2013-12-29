require 'spec_helper'

describe Item do
  before do
    @item = Item.make
    @item.save
  end

  it "should create a valid Item" do
    @item.description.should_not be_nil
    @item.price.should == 10
    @item.quantity.should == 1

    @item.is_exempt.should be_false
    @item.is_import.should be_false

    @item.item_total.should == 10.0
    @item.tax_total.should be_nil
  end
end
