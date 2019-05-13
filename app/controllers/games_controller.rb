require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'...'Z').to_a
    @letter_array = []

    10.times { @letter_array.push(@letters.sample) }
  end

  def score
    @input = params[:input].upcase
    @letter_array = params[:letters]

    serialized_word = open("https://wagon-dictionary.herokuapp.com/#{@input}").read
    word = JSON.parse(serialized_word)
    # word_length = @input.length

    check_word_in_array = check_input_with_letter_array(@letter_array, @input)

    if check_word_in_array && word["found"]
      @result = "Yes you found the right word!"
    elsif check_word_in_array && word["found"] == false
      @result = "This word is not an English word"
    else
      @result = "This word is not in the given letters"
    end
  end

  def check_input_with_letter_array(letter_array, input)
    input.chars.all? do |letter|
      array_letter_count = letter_array.count(letter)
      input_letter_count = input.count(letter)
      array_letter_count >= input_letter_count
    end
  end
end
