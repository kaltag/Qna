# frozen_string_literal: true

class SubscriptionPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user&.id == record.subscriber
  end
end
