class Comment < ActiveRecord::Base
  validates :body, presence: true
  validates :parent, presence: true

  belongs_to :parent
  belongs_to :game
  belongs_to :pod
end
