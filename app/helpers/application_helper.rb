module ApplicationHelper
  def record_klass(record)
    record.presence ? 'btn-success' : 'btn-danger'
  end
end
