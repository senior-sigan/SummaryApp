class App.Participant extends Spine.Model
  @configure 'Participant', 'name', 'surname', 'score', 'email'
  @extend Spine.Model.Ajax

  fullName: -> [@name, @surname].join(' ')