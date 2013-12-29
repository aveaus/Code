describe("Item", function() {
  var item = new Item(10, 1, "an item", false, false)
  var exempt = new Item(12, 1, "an item", true, false)
  var imported = new Item(3, 2, "an item", false, true)
  var exemptAndImported = new Item(5, 3, "an item", true, true)

  it("should create a valid item", function() {
    expect(item.price).toEqual(10);
    expect(item.quantity).toEqual(1);
    expect(item.description).toEqual("an item");
    expect(item.isExempt).toEqual(false);
    expect(item.isImport).toEqual(false);
  });

  it("should round to the nearest nickle", function(){
    expect(item.roundToNearestNickle(1.00)).toEqual(1.00)
    expect(item.roundToNearestNickle(1.01)).toEqual(1.05)
    expect(item.roundToNearestNickle(1.04)).toEqual(1.05) 
    expect(item.roundToNearestNickle(1.06)).toEqual(1.06)
    expect(item.roundToNearestNickle(1.09)).toEqual(1.09)
  });

  it("should calculate the cost total", function(){
    expect(item.costTotal()).toEqual(10)
    expect(exempt.costTotal()).toEqual(12)
    expect(imported.costTotal()).toEqual(6)
    expect(exemptAndImported.costTotal()).toEqual(15)
  });

  it("should calculate the tax total", function(){
    expect(item.taxTotal(0.1, 0.05)).toEqual(1)
    expect(exempt.taxTotal(0.1, 0.05)).toEqual(0)
    expect(imported.taxTotal(0.1, 0.05)).toEqual(0.9)
    expect(exemptAndImported.taxTotal(0.1, 0.05)).toEqual(0.75)
  })

  it("should calculate the price total", function(){
    expect(item.priceTotal(0.1, 0.05)).toEqual(11)
    expect(exempt.priceTotal(0.1, 0.05)).toEqual(12)
    expect(imported.priceTotal(0.1, 0.05)).toEqual(6.90)
    expect(exemptAndImported.priceTotal(0.1, 0.05)).toEqual(15.75)
  })
});