class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    if word == nil
      raise(ArgumentError)
    end
    word = word.downcase
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    unless letter != nil && letter.match?(/[[:alpha:]]/) && letter.size == 1
      raise(ArgumentError)
    end
    letter = letter.downcase
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def check_win_or_lose
    if @wrong_guesses.size >= 7
      :lose
    elsif @word.chars.all? { |letter| @guesses.include?(letter) }
      :win
    else
      :play
    end
  end

  def word_with_guesses
    output = ''
    @word.chars do |letter|
      if @guesses.include?(letter)
        output << letter
      else
        output << '-'
      end
    end
    output
  end

  attr_accessor :word, :guesses, :wrong_guesses

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
