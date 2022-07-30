class Word

  attr_reader :word_a, :word_flex, :letters_guessed, :letters_wrong
  attr_accessor :attempts_left


  def initialize(word)
    @word_a = word.split('')
    @word_flex = Array.new(word.split(''))
    @attempts_left = 5
    @letters_guessed = []
    @letters_wrong =[]
  end

  def draw
    word_a.each do |char|
      if letters_guessed.include?(char)
        print "#{char} " 
      else
        print "_ "
      end
    end
  end

  def check_double(char)
    if letters_guessed.include?(char) ||   letters_wrong.include?(char)
      puts "You already tried this one."
      true
    end
  end

  def check_match(char)
    if word_flex.include?(char)
      self.letters_guessed << char
      self.word_flex.delete(char)

    else
      self.letters_wrong << char
      self.attempts_left -= 1
      puts "Wrong. You have #{attempts_left} attempts left.\n\n"
    end
  end

  def self.save_game
    YAML.dump
  end
end

#puts "Enemy player, choose a word."
word = Word.new("hi")
word.draw


while word.attempts_left > 0
  puts "\nAttempts left: #{word.attempts_left}"
  puts "\nLetters used: #{[word.letters_guessed, word.letters_wrong].flatten}" if [word.letters_guessed, word.letters_wrong].flatten.empty? == false
  puts "Choose a letter."


  char = gets.chomp

  next if word.check_double(char) == true

  word.check_match(char)

  word.draw

  if word.letters_guessed.sort == word.word_a.uniq.sort
    puts "\nYou win."
    break
  end

  if word.attempts_left == 0
    puts "\nYou lose. The word is '#{word.word_a.join('')}'"
    break
  end
end 