# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes %i[id email admin created_at updated_at]
end
