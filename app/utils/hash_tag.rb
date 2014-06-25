class HashTag
  QUERY_URL = 'https://twitter.com/search/?src=hash&q='

  def initialize(tags)
    @query = tags.gsub('#', '%23')
  end

  def url
    "#{QUERY_URL}#{@query}" unless @query.blank?
  end
end