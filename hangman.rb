class HumanPlayer

  #These are the methods if it's human's turn to guess

  def guess_letter
    print "Guess a letter: "
    gets.chomp
  end

  #These are the methods if it's computer's turn to guess

  def pick_word
  print "Think of a word for the computer to guess. How many letters does your word have? "
  @word_length = Integer(gets.chomp)
  end

  def confirm_letter(letter)
    print "The computer picked letter #{letter}. Type in your word as underscores with the letter if it exists in your word (for example, if the computer guessed 'a' and your word is 'cat', type in '_a_'). "
    @human_feedback = gets.chomp
  end

  def correct_letters_empty?
    correct_letters == nil
  end

  def correct_letters
    @correct_letters
  end

  def store_letter(letter)
    @correct_letters = []
    @human_feedback.split.each do |item|
      if item != "_" && !@correct_letters.include?(item)
        @correct_letters << item
      end
    end
  end

  def won?
    return false if @human_feedback.nil?
    @human_feedback.count("_") == 0
  end
end

class ComputerPlayer


  def initialize
    @unused_letters = ("a".."z").to_a.shuffle
    @correct_letters = []
    # @letters = Hash.new(0)
  end
  #These are the methods if it's human's turn to guess

  def pick_word
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @computer_word = @dictionary.sample
  end

  def ask_letter
    print "Secret word: " + "_" * @word.length
  end

  def confirm_letter(letter)
    if @computer_word.include?(letter.downcase)
      print "#{letter} is in the word!\n"
      store_letter(letter.downcase)
    else
    end
  end

  def store_letter(letter)
    @correct_letters << letter
  end

  def won?
    @computer_word.split("").uniq.sort == @correct_letters.uniq.sort
  end

  #These are the methods if it's computer's turn to guess

  def guess_letter
    @unused_letters.pop
  end

  #These are the methods if it's computer's turn to guess and it's being strategic

  def dictionary_select(length)
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @new_list = @dictionary.select { |word| word.length == length }
    dictionary_narrow
  end

  def narrow(correct_letters)
    # @new_list = @new_list.select { |word| letter.each do { |correct_letter| word.include?(correct_letter) } }

     @new_list =  @new_list.select do |word|
       correct_letters.select do |letter|
        word.include?(letter)
        end.sort == correct_letters.sort
      end

    dictionary_narrow
  end

  def dictionary_narrow
    @letters = Hash.new(0)
    @new_list.each do |word|
      word.split("").each do |letter|
        @letters[letter] += 1
      end
    end
  end

  def guess_letter_strategic
    most_common_letter = @letters.key(@letters.values.max)
    @letters.delete(most_common_letter)
    @unused_letters.delete(most_common_letter)
    most_common_letter
  end

end

class Hangman
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play
    @secret_word = @player1.pick_word
    p @secret_word
    while true
      @player1.confirm_letter(@player2.guess_letter)
      break if @player1.won?
    end
    print "Congratulations, you guessed all of the letters of the word!"
  end

  def play_strategic
    @secret_word_length = @player1.pick_word
    @player2.dictionary_select(@secret_word_length)
    while true
      @player1.confirm_letter(@player2.guess_letter_strategic)

      @player2.narrow(@player1.correct_letters) unless @player1.correct_letters_empty?
      # p @player2.guess_letter_strategic
      break if @player1.won?
    end
    print "Congratulations, you guessed all of the letters of the word!"
  end
end


