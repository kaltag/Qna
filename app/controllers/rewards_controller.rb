# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!
end
