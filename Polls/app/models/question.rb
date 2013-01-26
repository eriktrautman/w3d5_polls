class Question < ActiveRecord::Base
  attr_accessible :poll_id, :body

  belongs_to :poll
  has_many :choices
  has_many :responses

  def generate_question
    print "What is your question? >> "
    self.body = gets.chomp
    self.save
    print "How many choices would you like to assign to your question? >> "
    num_choices = gets.chomp.to_i
    num_choices.times do
      c = Choice.new( :question_id => self.id )
      c.generate_choice
    end
  end
end