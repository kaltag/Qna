# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :setup_linkable, except: %i[show]
  before_action :load_link, only: %i[show]

  def show
    @link
  end

  private

  def load_link
    @link = Link.find(params[:index])
  end

  def setup_linkable
    Rails.logger.debug(params)
    @linkable = linkable.new(links: [Link.new])
  end

  def linkable
    params.each do |name, _value|
      if Object.const_defined?(name.classify) && name.classify.constantize.respond_to?(:reflect_on_association) && name.classify.constantize.reflect_on_association(:links)
        return name.classify.constantize
      end
    end
  end
end
