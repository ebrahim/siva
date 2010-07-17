class Comment < ActiveRecord::Base
	include ActsAsCommentable::Comment

	belongs_to :commentable, :polymorphic => true

	default_scope :order => 'created_at ASC'

	belongs_to :user
	belongs_to :language

	# install the acts_as_votable plugin if you
	# want user to vote on the quality of comments.
	#acts_as_voteable

	validates_presence_of :title
	validates_presence_of :comment
	validates_presence_of :language
	validates_size_of :title, :within => 3..50
end
