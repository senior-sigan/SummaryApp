class ParticipantFactory
  DOMAIN = 'summaryapp.heroku.com'

  def self.generate_email(name, surname)
    return nil if name.blank? || surname.blank?

    SmartTranslitter.t("#{name.mb_chars.downcase.to_s}.#{surname.mb_chars.downcase.to_s}@#{DOMAIN}").last.gsub(/[\'\"]/, '')
  end

  def self.construct(event, email, name, surname)
    email ||=  CalculatedParticipant.where(:'value.name' => name, :'value.surname' => surname).distinct(:id).last || generate_email(name, surname)
    Rails.logger.info "EMAIL #{email}"
    return nil if email.blank?

    participant = event.participants.find_or_initialize_by(email: email.strip.mb_chars.downcase.to_s)
    participant.name = name.strip if name
    participant.surname = surname.strip if surname

    participant
  end
end