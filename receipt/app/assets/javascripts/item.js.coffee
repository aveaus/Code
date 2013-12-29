class window.Item
  constructor: (@price, @quantity, @description, @isExempt, @isImport) ->
    @isExempt ||= false
    @isImport ||= false
    @uid = null

  # cost = price * quantity
  costTotal: ->
    return @price * @quantity

  # tax = sales + import
  taxTotal: (salesTax, importTax) ->
    @taxRate = 0
    @totalTax = 0

    # add both sales and import tax
    if salesTax? && importTax?
      #console.log("calculating tax")
      @taxRate += salesTax if !@isExempt
      @taxRate ||= 0
      @taxRate += importTax if @isImport
      @taxRate ||= 0

      @totalTax = @costTotal() * @taxRate

    return @roundToNearestNickle(@totalTax)

  # price = cost + tax
  priceTotal: (salesTax, importTax) ->
    #console.log(this)
    #console.log("cost total is "+@costTotal()+" and tax is "+@taxTotal(salesTax, importTax)+ " total is "+(@costTotal() + @taxTotal(salesTax, importTax)))
    return parseFloat(accounting.toFixed(@costTotal() + @taxTotal(salesTax, importTax), 2))

  # round to the nearest 0.05 if the price is lower than 0.05 
  # 1.50 => 1.50, 1.51 => 1.55, 1.56 => 1.56
  roundToNearestNickle: (cost) ->
    # round to the hundreds decimal first
    # Javascript float pt precision hack
    cost = parseFloat(accounting.toFixed(cost, 2))
    #console.log("cost is "+cost)
    # round up if the hundredth decimal is less than 0.05
    decimal = Math.round((cost % 1) * 100)
    #console.log("decimal is "+decimal)
    hundredth = Math.round(decimal % 10)
    #console.log("hundredth is "+hundredth)
    if hundredth < 5 && hundredth > 0
      hundredthDiff = (5.0 - hundredth) / 100
      #console.log("hundredthDiff is "+hundredthDiff)
      cost += hundredthDiff

    # Javascript float pt precision hack
    return parseFloat(accounting.toFixed(cost, 2))

  # basic information for individual item quantity
  baseInfo: () ->
    return {"quantity" : @quantity, "description" : @description, "price" : @price}

  # price information for all items
  priceInfo: (salexTax, importTax) ->
    return {"quantity" : @quantity, "description" : @description, "total" : @priceTotal(salexTax, importTax)}