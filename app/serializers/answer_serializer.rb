# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id body user_id mark created_at updated_at]
end
