# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id title body created_at updated_at]
end
