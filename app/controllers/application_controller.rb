# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do |_exception|
    respond_to do |format|
      format.html do
        flash[:alert] = 'You are not authorized to perform this action.'

        redirect_to(request.referer || root_path)
      end
    end
  end

  def search
    @searchables = ElasticsearchService.new(params[:searchables_model], params[:query]).search
    render 'search/index'
  end
end
