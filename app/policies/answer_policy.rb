# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user
  end

  def new?
    create?
  end

  def update?
    user&.id == record.user&.id
  end

  def edit?
    update?
  end

  def destroy?
    user&.id == record.user&.id
  end

  def mark?
    user&.id == record.question.user&.id
  end
end
