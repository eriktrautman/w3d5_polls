class Poll < ActiveRecord::Base
  attr_accessible :user_id, :team_id, :name, :restricted

  belongs_to :user
  belongs_to :team
  has_many :questions

  def populate_poll
    print "What is the name of your poll? >> "
    self.name = gets.chomp
    save
    print "How many questions do you want to have in Poll #{self.name}? >> "
    num_question = gets.chomp.to_i
    num_question.times do
      q = Question.create(:poll_id => self.id)
      q.generate_question
    end
  end

end