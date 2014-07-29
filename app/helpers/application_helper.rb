module ApplicationHelper
  def record_klass(record)
    record.presence ? 'btn-success' : 'btn-danger'
  end

  def record_newcomer_klass(record)
    'success' if record.newcomer
  end
end
