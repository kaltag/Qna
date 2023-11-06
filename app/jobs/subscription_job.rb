# frozen_string_literal: true

class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(object)
    SubscriptionService.new.send_update_with(object)
  end
end
