class App.Participants extends Spine.Controller
  constructor: ->
    super
    App.Participant.bind 'refresh', @addAll
    @el.html JST["app/views/loading"]
    App.Participant.fetch()

  addAll: (parties) =>
    console.log parties
    @el.html JST["app/views/participants/index"](parties)