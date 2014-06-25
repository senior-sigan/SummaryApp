class StatisticsController < ApplicationController
  def index
    records = StatisticsFactory.records_per_event
    newcomers = StatisticsFactory.newcomers_rb
    participations = StatisticsFactory.participation
    @statistics = Join.new(records, newcomers, participations).by('event_id')
  end
end
