class window.Template
  constructor: () ->
    @tpls = []
    that = this

    # load the templates from server
    templates = ['list_item', 'order_total']
    $.each templates, (i, e) ->
      $.ajax({
        url : 'home/templates',
        data: "template="+e,
        success : (data) ->
          # store the compiled template
          that.tpls[e] = Handlebars.compile(data)
          return
        async : false, 
        dataType : 'html'
      })
      return

    return

  # render the template
  render: (item, which) ->
    template = @tpls[which]
    return template(item)
