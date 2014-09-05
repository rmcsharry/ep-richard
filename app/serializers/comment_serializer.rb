class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :parent_name
end
