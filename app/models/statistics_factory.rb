class StatisticsFactory
  NewcomersStatistics = Struct.new(:event_id, :newcomers_count)
  RecordsPerEventStatistics = Struct.new(:event_id, :name, :date, :records_count)
  ParticipationStatistics = Struct.new(:event_id, :name, :date, :participation_count)
  RecordsStatisctics = Struct.new(:id, :email, :name, :surname, :presence, :newcomer)

  def self.newcomers
    #TODO - this sql is wrong - min event date not correspond to min event id
    ActiveRecord::Base.connection.execute(
      Arel::Nodes::SqlLiteral.new <<-SQL
        SELECT COUNT(*) as newcomers, event_id FROM(
        SELECT records.email as email, MIN(events.date) as date, MIN(records.event_id) as event_id
        FROM records INNER JOIN events ON events.id = records.event_id
        GROUP BY email) as records_dates
        GROUP BY event_id
      SQL
    ).map {|hash| NewcomersStatistics.new(hash['event_id'], hash['newcomers'])}
  end

  def self.newcomers_rb
    records = Record.unscoped.joins(:event).select('records.email','events.date','records.event_id').order('events.date ASC')
    newcomers = {}
    records.each do |record|
      if newcomers[record.email].nil? || newcomers[record.email].date > record.date
        newcomers[record.email] = OpenStruct.new(event_id: record.event_id, date: record.date)
      end
    end

    events = {}
    newcomers.each do |k,v|
      events[v.event_id] = (events[v.event_id] || 0) + 1
    end

    events.map {|k,v| NewcomersStatistics.new(k, v)}
  end

  def self.newcomers_at_event(event)
    ActiveRecord::Base.connection.execute(
      Arel::Nodes::SqlLiteral.new <<-SQL
        SELECT r.id, r.email, r.name, r.surname, r.presence, COALESCE(c.count,0) as counter
        FROM (
          SELECT records.email, count(*) 
          FROM records 
          INNER JOIN events 
          ON records.event_id = events.id 
          WHERE events.date < (SELECT date FROM events WHERE id = #{event.id})
          GROUP BY records.email) as c 
        RIGHT OUTER JOIN records as r 
        ON r.email = c.email
        WHERE r.event_id = #{event.id}
        ORDER BY r.surname ASC
      SQL
    ).map {|record| RecordsStatisctics.new(record['id'], record['email'], record['name'], record['surname'], record['presence'] == 't', record['counter'].to_i.zero? ? true : false) }
  end

  def self.records_per_event
    Record.unscoped
      .joins(:event)
      .group(:event_id, 'events.name', 'events.date')
      .order('events.date ASC')
      .count
      .map {|k,v| RecordsPerEventStatistics.new(k[0], k[1], k[2], v)}
  end

  def self.participation
    Record.unscoped
      .joins(:event)
      .group(:event_id, 'events.name', 'events.date', 'records.presence')
      .order('events.date ASC')
      .having(presence: true)
      .count
      .map {|k,v| ParticipationStatistics.new(k[0], k[1], k[2], v)}
  end
end