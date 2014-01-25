$ = jQuery
class App.RegistrationsImport extends Spine.Controller
  elements:
    '#dropZone': 'zone'
    '#thefile': 'file_input'
    '#headers': 'headers'
    '.btn.btn-success': 'btn'
    '#loading': 'status'
    '#alert': 'alrt'

  events:
    'drop #dropZone': 'dropped'
    'submit form': 'send'
    'change #thefile': 'changed'
    'click #dropZone': 'clicked'
    'dragover #dropZone': 'over'
    'dragleave #dropZone': 'leaved'

  constructor: ->
    super
    throw "event_id required" unless @event_id
    @html JST["app/views/registrations/import"]

  send: (event) =>
    event.preventDefault()
    @alrt.html ""
    @alrt.removeClass "alert alert-danger alert-success"
    fields = ( field.value for field in @file_inputs when field.checked is true )
    form = new FormData()
    form.append "fields",JSON.stringify(fields)
    form.append "file", @file
    $(document).ajaxSend @sending
    req = $.ajax
      url: "/events/#{@event_id}/registrations/save_import.json"
      type: "POST"
      data: form
      processData: false
      contentType: false
    req.fail @fail
    req.done @done
    req.always @always

  sending: (ev,req,sets) =>
    @status.html JST["app/views/loading"]

  fail: (xhr,st,err) =>
    console.log [xhr, st, err]
    @alrt.addClass "alert alert-danger"
    try
      @alrt.html JST["app/views/errors"](xhr.responseJSON.errors.base)
    catch e
      @alrt.html JST["app/views/errors"](["Something wents WRONG. May be you have BAD file!!"])  

  done: (xhr,st) =>
    @alrt.addClass "alert alert-success"
    @alrt.html "Success"
    @headers.html ""
    #@btn.addAttr 'disabled'
    console.log xhr
    console.log st  

  always: =>
    @status.html ""

  changed: (event) =>
    @zone.addClass 'drop'
    files = @file_input[0].files
    @parse file for file in files

  clicked: (event) =>
    @alrt.removeClass "alert alert-danger alert-success"
    @file_input.trigger 'click'

  dropped: (event) =>
    event.preventDefault()
    @zone.addClass 'drop'
    file = event.dataTransfer.files[0]
    @parse file
    #@parse file for file in files

  over: (event) =>
    @zone.addClass 'hover'

  leaved: (event) =>
    @zone.removeClass 'hover'

  parse: (file) =>
    console.log file
    @status.html JST["app/views/loading"]
    @file = file
    reader = new FileReader()
    reader.onload = @loaded
    reader.readAsText file

  loaded: (event) =>
    @zone.removeClass 'drop'
    try
      result = event.target.result
      @data = result
      head = $.csv.toArrays(result)[0]
    catch error
      @zone.removeClass 'drop'
      @zone.addClass 'error'
      @status.html ""
      @alrt.html JST["app/views/errors"](["Something wents WRONG. May be you have BAD file!!\n#{error}"])
      return false
    @headers.html JST['app/views/registrations/headers'](head) 
    @status.html ""
    @file_inputs = $("input[type=checkbox]")
    if @file_inputs.length > 0 
      @btn.removeAttr 'disabled'
