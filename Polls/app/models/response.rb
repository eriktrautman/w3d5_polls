class Response < ActiveRecord::Base
  attr_accessible :user_id, :choice_id, :question_id

  belongs_to :user
  belongs_to :question
  validates :user_id, :uniqueness => { :scope => :question_id,
    :message => "Sorry, only one response per question" }
end