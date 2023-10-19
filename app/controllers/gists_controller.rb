# frozen_string_literal: true

class GistsController < ApplicationController
  before_action :load_gist, only: %i[show]

  private

  def load_gist
    @gist = Link.find(params[:id])
  end
end
