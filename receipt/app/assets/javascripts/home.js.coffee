# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  # Create a new order form
  order = new Order(0.1, 0.05)

  # Get HTML templates from server
  template = new Template()

  # bind all event handlers to the form
  home = new Form(order, template)

  return


