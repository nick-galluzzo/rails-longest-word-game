require 'open-uri'
require 'json'

class GamesController < ApplicationController
  ALPHABET = ('a'..'z').to_a

  def new
    @letters = []
    @letters = generate_letters(@letters)
  end

  def score
    @attempt = params[:word]
    @grid = params[:letters]
    @found = valid_word(@attempt)
    @valid = valid_chars?(@grid, @attempt)

    @result = define_result(@attempt, @grid)
  end

  private

  def generate_letters(letters_arr)
    10.times do
      letters_arr << ALPHABET[rand(ALPHABET.length)]
    end

    letters_arr
  end

  def valid_chars?(letters, attempt)
    attempt = attempt.downcase.chars
    attempt.all? { |char| attempt.count(char) <= letters.count(char) }
  end

  def valid_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response = RestClient.get(url)
    words = JSON.parse(response.body)

    words['found']
  end

  def define_result(attempt, letters)
    if !@found
      @result = "Sorry, #{attempt} is not an English word."
    elsif !@valid
      @result = "Sorry, but #{attempt} can't be built out of #{letters.split(' ').join(', ')}"
    else
      @result = "Congratulations! #{attempt} is a valid English word!"
    end

    @result
  end
end
