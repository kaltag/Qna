# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: %i[destroy]

  def create
    @subscription = Subscription.new(subscription_params)
    authorize @subscription

    @subscription.save
  end

  def destroy
    @subscriptable = @subscription.subscriptable
    @subscription.destroy!
    @subscription = nil
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:subscriptable_type, :subscriptable_id).merge(subscriber: current_user)
  end
end
