class User < ActiveRecord::Base
  attr_accessible :screen_name, :team_id

  validates :screen_name, :uniqueness => true
  has_many :polls
  has_many :responses
  belongs_to :team

  def create_poll
    print "Do you want this poll to be restricted to your team? (y/n) >> "
    restricted = case gets.chomp.downcase[0]
      when 'y' then true
      else false
      end
    p = Poll.create(:user_id => self.id, :team_id => self.team_id,
      :restricted => restricted)
    p.populate_poll
  end
end