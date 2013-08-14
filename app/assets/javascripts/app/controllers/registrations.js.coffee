$ = jQuery
class App.RegistrationsImport extends Spine.Controller
  elements:
    '#dropZone': 'zone'
    '#thefile': 'file_input'
    '#headers': 'headers'
    '.btn.btn-success': 'btn'

  events:
    'drop #dropZone': 'dropped'
    'submit form': 'send'
    'change #thefile': 'changed'
    'click #dropZone': 'clicked'
    'dragover #dropZone': 'over'
    'dragleave #dropZone': 'leaved'

  constructor: ->
    super
    throw "event required" unless @event
    @html JST["app/views/registrations/import"]

  send: (event) =>
    event.preventDefault()
    fields = ( field.value for field in @file_inputs when field.checked is true )
    imprt = new App.RegistrationImport({event_id: @event, file: @data, fields: fields})
    imprt.send()
    console.log imprt.ajax()

  changed: (event) =>
    console.log event
    @zone.addClass 'drop'
    files = @file_input[0].files
    @parse file for file in files

  clicked: (event) =>
    console.log event
    @file_input.trigger 'click'

  dropped: (event) =>
    console.log event
    event.preventDefault()
    @zone.addClass 'drop'
    files = event.dataTransfer.files
    @parse file for file in files

  over: (event) =>
    @zone.addClass 'hover'

  leaved: (event) =>
    @zone.removeClass 'hover'

  parse: (file) =>
    console.log file
    unless file.type.match('text/*')
      @zone.removeClass 'drop'
      @zone.addClass 'error'
      false
    else
      reader = new FileReader()
      reader.onload = @loaded
      reader.readAsText file 

  loaded: (event) =>
    @zone.removeClass 'drop'
    result = event.target.result
    @data = result
    head = $.csv.toArrays(result)[0]
    @headers.html JST['app/views/registrations/headers'](head) 
    @file_inputs = $("input[type=checkbox]")
    if @file_inputs.length > 0 
      @btn.removeAttr 'disabled'
