# frozen_string_literal: true

module Subscriptable
  extend ActiveSupport::Concern

  included do
    before_action :set_subscription, only: %i[show]
  end

  private

  def set_subscription
    @subscription = Subscription.find_by(subscriber: current_user, subscriptable: subscriptable)
  end

  def subscriptable
    @subscriptable ||= controller_name.classify.constantize.find(params[:id])
  end
end
