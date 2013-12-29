describe("Order", function() {
  var order = new Order(0.1, 0.05)
  order.items.push(new Item(10, 1, "an item", false, false))
  order.items.push(new Item(4, 2, "an item", true, true))

  it("should create a valid order", function() {
    expect(order.salesTax).toEqual(0.1);
    expect(order.importTax).toEqual(0.05);
    expect(order.items.length).toEqual(2);
  });
  
  it("should calculate the cost total", function(){
    expect(order.costTotal()).toEqual(18.00)
  });

  it("should calculate the tax total", function(){
    expect(order.taxTotal()).toEqual(1.4)
  });

  it("should calculate the price total", function(){
    expect(order.priceTotal()).toEqual(19.4)
  })
});