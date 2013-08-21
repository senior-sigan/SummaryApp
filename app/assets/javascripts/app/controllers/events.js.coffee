class App.EventsStats extends Spine.Controller
  elements:
    '#realsgraph': 'realsGraph'
    '#newsgraph': 'newsGraph'
    '#loading': 'loading'

  constructor: ->
    super
    @html JST["app/views/events/stats"]
    App.Event.bind 'refresh',@draw
    App.Event.url = "stats"
    App.Event.fetch()
    @loading.html JST["app/views/loading"]


  draw: =>
    @loading.html ""
    reals_ctx = @realsGraph.get(0).getContext "2d"
    news_ctx = @newsGraph.get(0).getContext "2d"
    events = App.Event.all()
    
    options = {
      scaleOverride: true,
      scaleSteps: 10,
      scaleStepWidth: 10,
      scaleStartValue: 0
    }
    realss_stats = new Chart(reals_ctx).Line @realsData(events),options
    news_stats = new Chart(news_ctx).Line @newsData(events),options

  realsData: (events) =>
    data = {
      labels: events.map(@names)
      datasets: [
        {       
          fillColor: "rgba(220,220,220,0.5)",
          strokeColor: "rgba(220,220,220,1)",
          pointColor: "rgba(220,220,220,1)",
          pointStrokeColor: "#fff", 
          data: events.map(@reals)
        },
      ]
    }

  newsData: (events) =>
    data = {
      labels: events.map(@names)
      datasets: [
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data : events.map(@newcomers)
        }
      ]
    }

  names: (el) ->
    el.name

  reals: (el) ->
    el.real_ratio

  newcomers: (el) ->
    el.newcomer_ratio