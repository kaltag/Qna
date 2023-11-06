# frozen_string_literal: true

class SubscriptionService
  SUBSCRIPTION_TYPE = {
    answer: :send_question_update
  }.freeze

  def send_update_with(object)
    send SUBSCRIPTION_TYPE[object.class.to_s.underscore.to_sym], object
  end

  private

  def send_question_update(object)
    object.question.subscribers.find_each(batch_size: 500) do |user|
      QuestionUpdateMailer.send_updates(user, object).deliver_later
    end
  end
end
