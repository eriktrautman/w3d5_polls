class Pollster
  def run
    puts
    puts "Welcome to Pollser! Get your poll up!".center(45, '-')
    puts
    sign_in
    puts
    puts "Welcome #{@user.screen_name}!"
    puts
    command_line

  end

  def sign_in
    print "What is your user name? ('new' if new user!) >> "
    name = gets.chomp
    login(name)
  end

  def login(name)
    case name
    when 'new' 
      gen_user
    else
      lookup(name)
    end
  end

  def gen_user
    while true
      print "What do you want to be named? >> "
      name = gets.chomp.downcase
      print "What team are you on? ('f' for free agent) >> "
      team = get_team
      @user = User.create(:screen_name => name, :team_id => team)
      break if @user.valid?
      puts "Sorry, name has been taken!"
    end
  end

  def get_team
    name = gets.chomp
    case name
    when 'f' then nil
    else
      t = Team.where(:name => name).first.id
    end
  end

  def lookup(name)
    @user = User.where(:screen_name => name).first
  end

  def command_line
    while true
      print "Would you like to (t)ake a poll, (m)ake a poll, see (r)esults, "
      print "(s)how user stats, (c)reate a team, or (q)uit? >> "
      command = gets.chomp.downcase
      case command
      when "t" then take_poll
      when "m" then make_poll
      when "r" then see_results
      when "s" then show_user_statistics
      when "c" then create_team
      when "q"
        puts "Thanks for polling!"
        exit
      else
        puts "try again"
      end
    end
  end

  def take_poll
    print "Which poll do you want to take (enter the name)? >> "
    poll = Poll.where(:name => gets.chomp).first
    if poll.restricted&& @user.team_id != poll.team_id
      puts "Sorry this is a private poll!"
      return
    end
    print_poll(poll)
  end

  def print_poll(poll)
    puts
    puts "You are about to take the poll: #{poll.name}"
    puts "".center(45, "-")
    print_questions(poll.questions)
    puts
  end

  def print_questions(questions)
    questions.each do |question|
      puts question.body
      print_choices(question.choices, question)
      puts
    end
  end

  def print_choices(choices, question)
    choices.count.times do |i|
      puts "#{i+1} | #{choices[i].body}"
    end
    puts
    print "make a choice! >> "
    choice_id = choices[gets.chomp.to_i - 1].id
    response = Response.create(:user_id => @user.id,
      :question_id => question.id, :choice_id => choice_id)
  end

  def make_poll
    @user.create_poll
  end

  def see_results
    print "Which poll would you like to see the results for? >> "
    poll = Poll.where(:name => gets.chomp).first
    puts
    puts "#{poll.name}".center(45, "-")
    puts
    poll.questions.includes(:choices).each do |q|
      puts q.body
      print_choices_with_results(q.choices, q)
      puts
    end
    puts "".center(45, "-")
    puts
  end

  def print_choices_with_results(choices, question)
    choices.each do |c|
      print "  #{c.body[0..24]}".ljust(25, " ")
      puts "| #{c.responses.count}"
    end
  end

  def show_user_statistics
    print "Which user would you like to see stats for? >> "
    user = User.where(:screen_name => gets.chomp.downcase).first
    puts
    print "#{user.screen_name}".center(45, "-")
    puts
    puts "~POLLS~"
    Poll.where(:user_id => user.id).each do |poll|
      puts "  #{poll.name}"
    end
    puts
    puts "~RESPONSES~"
    print "Has responded to #{Response.where(:user_id => user.id).count} questions"
    puts
    puts "".center(45, "~*~")
    puts
  end

  def create_team
    puts "What do you want your team to be named?"
    name = gets.chomp
    Team.create(:name => name)
  end
end

Pollster.new.run