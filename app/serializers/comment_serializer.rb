class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :parent_name
end
