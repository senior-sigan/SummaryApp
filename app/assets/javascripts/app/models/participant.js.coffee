class App.Participant extends Spine.Model
  @configure 'Participant', 'name', 'surname', 'score', 'email', 'categories'
  @extend Spine.Model.Ajax

  fullName: -> [@name, @surname].join(' ')
  home_url: -> "/participants/#{@id}"