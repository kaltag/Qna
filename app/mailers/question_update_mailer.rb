# frozen_string_literal: true

class QuestionUpdateMailer < ApplicationMailer
  def send_updates(user, object)
    @question = object.question
    @object = object

    mail to: user.email
  end
end
