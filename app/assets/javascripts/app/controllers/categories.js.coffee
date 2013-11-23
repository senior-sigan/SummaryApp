$ = jQuery
class App.Categories extends Spine.Controller
  events:
    'click #recalculate': 'recalculate'

  elements:
    "#cats-list": 'list'
    "#participants": 'participants'

  constructor: ->
    super
    @html JST["app/views/categories/index"]
    App.Category.bind 'refresh', @addAll
    App.Category.bind 'create', @addOne
    App.Participant.bind 'refresh', @addParticipant

    @list.html JST["app/views/loading"]
    App.Category.fetch()

  addAll: =>
    @list.html ""
    console.log App.Category.all()
    App.Category.each(@addOne)

  addOne: (category) =>
    view = new App.CategoryItem(item: category)
    @list.append(view.render().el)

  addParticipant: (participants)=>
    @participants.html JST["app/views/categories/users"](participants) 

  recalculate: (ev) =>
    ev.preventDefault()
    req = $.ajax
      url: '/categories/recalculate'
      type: 'POST'
      success: (ev) ->
        App.Category.fetch()

class App.CategoryItem extends Spine.Controller
  tag: "li"

  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)
  
  render: (item) =>
    @item = item if item
    @replace JST['app/views/categories/item'](@item)
    @el.on("click",@click)
    @

  remove: =>
    @el.remove()

  click: (ev) =>
    ev.preventDefault()
    App.Participant.scope = "#{App.Category.url}/#{@item.name}"
    $("#participants").html JST["app/views/loading"]
    App.Participant.fetch() 

class App.CategoryShow extends Spine.Controller
  elements:
    "#users": 'users'
    "#events": 'events'

  constructor: ->
    super
    throw "@category_id required" unless @category_id
    @html JST["app/views/categories/show"]
    App.Participant.scope = "#{App.Category.url}/#{@category_id}"
    App.Participant.bind 'refresh', @addParticipant
    App.Event.bind 'refresh', @addEvent

    @users.html JST["app/views/loading"]
    App.Participant.fetch()

  addParticipant: =>
    console.log App.Participant.all()
    @users.html JST["app/views/categories/users"](App.Participant.all())

  addEvent: =>
    console.log App.Event.all()
