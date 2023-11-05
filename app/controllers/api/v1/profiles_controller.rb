# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def others
    @others = User.where.not(id: current_resource_owner)
    render json: @others
  end
end
