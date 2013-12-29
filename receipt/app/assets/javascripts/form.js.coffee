# encapsulate all Form functions
class window.Form
  constructor: (order, template) ->
    @order = order
    @template = template
    @container = $('div.container')

    that = this

    # Assign handler for adding additional items
    @container.find('div.list button#add').on 'click', (evt) ->

      # Get all essential information about the item to add
      price = that.container.find('input.itemPrice').val()
      quantity = that.container.find('input.itemQuantity').val()
      description = that.container.find('input.itemDesc').val()
      #console.log('I am adding '+price+' for '+quantity+' and '+description)

      # show error if any of the essential information is not entered
      if description == "" || price == "" || quantity == ""
        that.container.find('.alert-error span').html("You need to enter all values.")
        that.container.find('.alert-error').show()
      else
        # get exemption and import information
        exempt = that.container.find('input.itemExempt').prop('checked')
        imported = that.container.find('input.itemImport').prop('checked')
        #console.log('they are exempt '+exempt + ' imported '+imported)

        # Create a new item and add it to the order
        item = new Item(price, quantity, description, exempt, imported)
        that.order.addItem(item)

        # clear the input first
        that.clearInput()

        # display the newly added item
        html = template.render(item.baseInfo(), 'list_item')
        that.container.find('table tbody').append(html)

    # Assign handler for clear/calculate the cost
    @container.find('div.form button#clear').on 'click', (evt) ->
      that.clearForm()

    # Assign handler to calculate and print out the receipt
    @container.find('div.form button#calculate').on 'click', (evt) ->
      html = template.render(that.order.priceInfo(), 'order_total')
      that.container.find('table tbody').html(html)

  # clear the form
  clearInput: () ->
    @container.find('input.itemPrice').val('')
    @container.find('input.itemQuantity').val('')
    @container.find('input.itemDesc').val('')
    @container.find('input.itemExempt').attr('checked', false)
    @container.find('input.itemImport').attr('checked', false)

  # remove all entries from the basket
  clearForm: () ->
    @container.find('.basket table tbody').html('')