class Choice < ActiveRecord::Base
  attr_accessible :question_id, :body

  belongs_to :question
  has_many :responses

  def generate_choice
    print "What is the text of the choice? >> "
    self.body = gets.chomp
    save
  end
end