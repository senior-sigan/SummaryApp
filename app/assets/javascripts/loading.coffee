$(document).on 'page:fetch', ()->
  $('.loading-indicator').show()
  $('body').addClass('stop-scrolling')

$(document).on 'page:change', ()->
  $('.loading-indicator').hide()
  $('body').removeClass('stop-scrolling')