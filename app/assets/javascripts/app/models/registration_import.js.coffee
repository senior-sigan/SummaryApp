class App.RegistrationImport extends Spine.Model
  @configure 'RegistrationImport', 'file', 'fields','event_id'
  @extend Spine.Model.Ajax
  send: =>
    $.post "/events/" + this.event_id + "/registrations/save_import", @.toJSON()