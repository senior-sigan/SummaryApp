module EventsHelper
  def link_to_twitter_hash_tag tags
    link_to tags, "https://twitter.com/search/?src=hash&q=#{tags.gsub('#','%23')}" unless tags.blank?
  end

  def participant_klass(part)
    'danger' unless part.was?
  end
end
