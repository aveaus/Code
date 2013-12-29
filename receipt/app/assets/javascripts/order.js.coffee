class window.Order
  constructor: (@salesTax, @importTax) ->
    @items = []

  addItem: (item) ->
    item.uid = @items.length
    @items.push(item)

  # calcualte the total tax for all items in the order
  taxTotal: () ->
    @totalTax = 0
    for item in @items
      @totalTax += item.taxTotal(@salesTax, @importTax)

    # Javascript float pt precision hack
    return parseFloat(accounting.toFixed(@totalTax, 2))

  # calculate total cost for all items in the orders
  costTotal: () ->
    @totalCost = 0
    for item in @items
      @totalCost += item.costTotal()
      #console.log('item cost is '+item.cost_total()+", total is "+@totalCost)

    # Javascript float pt precision hack
    return parseFloat(accounting.toFixed(@totalCost, 2))

  # calculate the total price for all items in the orders
  priceTotal: () ->
    @totalPrice = 0
    for item in @items
      @totalPrice += item.priceTotal(@salesTax, @importTax)

    # Javascript float pt precision hack
    return parseFloat(accounting.toFixed(@totalPrice, 2))

  # Get all the pricing info to display
  priceInfo: () ->
    @info = {}
    @info['items'] = []
    console.log(@items)
    for item in @items
      @info['items'].push(item.priceInfo(@salesTax, @importTax))

    @info['tax'] = @taxTotal()
    @info['total'] = @priceTotal()
    console.log(@info)    
    return @info

  # clean all items
  clearOrder: () ->
    @items = []
