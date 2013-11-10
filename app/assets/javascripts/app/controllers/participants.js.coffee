class App.ParticipantsCategorize extends Spine.Controller
  events:
    'click .participant': 'check'
    'click .toggle': 'toggle'

  constructor: ->
    super
    tags = $('#categories').data 'tags'
    $('#categories').select2
      tags: tags


  check: (ev) =>
    checkBox = $(ev.currentTarget).find 'input[type=checkbox]'
    if checkBox.prop('checked')
      checkBox.prop 'checked', false
      $(ev.currentTarget).removeClass 'selected'
    else
      checkBox.prop 'checked',true
      $(ev.currentTarget).addClass 'selected'
   
    ev.preventDefault()

  toggle: (ev) =>
    $(".participant").click()

class App.ParticipantsIndex extends Spine.Controller
  events:
    'click #recalculate': 'recalculate'

  constructor: ->
    super
    App.Participant.bind 'refresh', @addAll
    #@el.html JST["app/views/loading"]
    App.Participant.fetch()

  addAll: (parties) =>
    console.log parties
    @el.html JST["app/views/participants/index"](parties)

  recalculate: (ev) =>
    ev.preventDefault()
    req = $.ajax
      url: '/participants/recalculate'
      type: 'POST'
      success: (ev) ->
        App.Participant.fetch()

class App.ParticipantsActivity extends Spine.Controller
  constructor: ->
    super
    App.Participant.url = App.Participant.url('activity')
    App.Participant.bind 'refresh', @addAll
    @el.html JST["app/views/loading"]
    App.Participant.fetch()

  addAll: (parties) =>
    console.log parties
    @el.html JST["app/views/participants/activity"](parties)

class App.ParticipantsTop extends Spine.Controller
  constructor: ->
    super
    App.Participant.url = App.Participant.url('top')
    App.Participant.bind 'refresh', @addAll
    @el.html JST["app/views/loading"]
    App.Participant.fetch()

  addAll: (parties) =>
    console.log parties
    @el.html JST["app/views/participants/top"](parties)