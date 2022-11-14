require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...9).map { rand(65..90).chr }
  end

  def score
    @result_game = ''
    attempt = params['guess']
    letters = params['letters'].split('')
    @score = 0

    grid_lowercase = letters.map do |e|
      e.downcase
    end

    word_splitted = attempt.chars
    copy_grid = grid_lowercase
    if check_word(attempt) == false
      return @result_game = "Sorry but #{attempt} does not seems to be a valid English word..."
    end

    word_splitted.each do |c|
      if copy_grid.include?(c)
        copy_grid.delete_at(grid_lowercase.index(c))
      else
        return @result_game = "Sorry but #{attempt} can't be built of : #{params['letters'].gsub(' ', ', ')}"
      end
      @result_game = "Congratulation! #{attempt} is a valid word"
    end
    if session[:score].nil?
      session[:score] = attempt.size
    else
      session[:score] += attempt.size
    end
  end

  private

  def check_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)['found']
  end
end
