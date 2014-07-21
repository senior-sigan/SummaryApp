$ ->
  $('#events li').wookmark
    autoResize: true
    direction: 'left'
    align: 'left'
    container: $('.row')
    outerOffset: 10
    offset: 10
    comparator: (a, b)->
      if $(a).data('date') < $(b).data('date')
        -1
      else
        1