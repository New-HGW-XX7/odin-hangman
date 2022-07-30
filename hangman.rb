require 'yaml'
class Word

  attr_reader :word_a, :word_flex, :letters_guessed, :letters_wrong
  attr_accessor :attempts_left


  def initialize(word, word_flex = Array.new(word.split('')), attempts_left = 5, letters_guessed = [], letters_wrong = [])
    @word_a = word.split('')
    @word_flex = word_flex
    @attempts_left = attempts_left
    @letters_guessed = letters_guessed
    @letters_wrong = letters_wrong
  end

  def draw
    word_a.each do |char|
      if letters_guessed.include?(char)
        print "#{char} " 
      else
        print "_ "
      end
    end
    puts "\n"
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

  def create_yaml
    YAML.dump ({
      word_a: @word_a,
      word_flex: @word_flex,
      attempts_left: @attempts_left,
      letters_guessed: @letters_guessed,
      letters_wrong: @letters_wrong
    })
  end

  def save_game
    data = self.create_yaml
    save = File.open("save.txt", "w")
    save.puts data
    save.close
  end

  def self.load_game
    data_yaml = File.open("save.txt", "r")
    data = YAML.load(data_yaml)
    #p data_yaml
    #p data
    data[:word_a] = data[:word_a].join('')
    
    self.new(data[:word_a], data[:word_flex], data[:attempts_left], data[:letters_guessed], data[:letters_wrong])
  end
end


puts 'Do you want to load?'
if gets.chomp == 'y'
  word = Word.load_game 
else
  random_word = File.open("wordlist.txt", "r") { |list| list.select { |word| word.length > 4 and word.length < 13 }.sample.chomp }
  p random_word
  word = Word.new(random_word)
end

word.draw


while word.attempts_left > 0
  #puts "Do you wish to save your game? Press 'y'. Else press any other button"
  #word.save_game if gets.chomp == 'y'

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