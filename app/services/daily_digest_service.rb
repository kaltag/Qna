# frozen_string_literal: true

class DailyDigestService
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, today_questions).deliver_later
    end
  end

  private

  def today_questions
    @today_questions ||= Question.where(created_at: Time.current.all_day).to_a
  end
end
