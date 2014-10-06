# TODO it's just test
ev1 = Event.create(name: 'event_2', date: DateTime.now - 1.day)
ev2 = Event.create(name: 'event_1', date: DateTime.now - 2.day)
ev3 = Event.create(name: 'event_3', date: DateTime.now)

r1 = RecordsImporter.new(ev1)
r2 = RecordsImporter.new(ev2)
r3 = RecordsImporter.new(ev3)

r1.file = File.new("#{Rails.root}/spec/files/event_2.csv")
r2.file = File.new("#{Rails.root}/spec/files/event_1.csv")
r3.file = File.new("#{Rails.root}/spec/files/event_3.csv")

[r1,r2,r3].each(&:save)