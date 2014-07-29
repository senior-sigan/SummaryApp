$(document).ready ()->
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

$(document).on 'click', 'a.js-toggle', (ev) ->
  ev.preventDefault()
  $that = $(this)
  url = $that.data 'url'
  $.ajax
    type: 'POST'
    url: url
    success: (res) ->
      if res
        if res.status == true # was
          $that.removeClass 'btn-danger'
          $that.addClass 'btn-success'
          $that.find('span').removeClass 'glyphicon-remove'
          $that.find('span').addClass 'glyphicon-ok'
        else
          $that.removeClass 'btn-success'
          $that.addClass 'btn-danger'
          $that.find('span').removeClass 'glyphicon-ok'
          $that.find('span').addClass 'glyphicon-remove'
      else
        console.log 'Server error'