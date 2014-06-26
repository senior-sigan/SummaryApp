# TODO it's just test
@ev1 = Event.create(name: 'event_2', date: DateTime.now - 1.day)
@ev2 = Event.create(name: 'event_1', date: DateTime.now - 2.day)
@ev3 = Event.create(name: 'event_3', date: DateTime.now)

RecordsImporter.new(@ev1, File.new("#{Rails.root}/spec/files/event_2.csv")).save
RecordsImporter.new(@ev2, File.new("#{Rails.root}/spec/files/event_1.csv")).save
RecordsImporter.new(@ev3, File.new("#{Rails.root}/spec/files/event_3.csv")).save