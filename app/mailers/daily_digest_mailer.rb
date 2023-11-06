# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    @user = user
    mail to: user.email
  end
end
