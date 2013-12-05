#!/usr/bin/env ruby

require 'highline/import'

class Hangman
  attr_accessor :guesses, :max_guesses, :secret_text

  def initialize(secret_text)
    self.secret_text = secret_text
    self.guesses = []
    self.guesses << "\n" if letters_secret_text.first == "\n"
    self.max_guesses = modifications.size
  end

  def play
    while play?
      refresh_screen
      wait_for_guess
    end
    show_score
  end

private

  def bad_guesses
    letters_in_guesses - letters_secret_text
  end

  def letters_in_guesses
    guesses.uniq.sort
  end

  def letters_secret_text
    secret_text.split(//).uniq.sort
  end

  def lost?
    bad_guesses.size >= max_guesses
  end

  def modifications
    [
      head = bad_guesses.size > 0 ? '( )' : '   ',
      bad_guesses.size > 1 ? '|'   : ' ',
      bad_guesses.size > 2 ? '|'   : ' ',
      bad_guesses.size > 3 ? '/'   : ' ',
      bad_guesses.size > 4 ? '\\'  : ' ',
      bad_guesses.size > 5 ? '\\'  : ' ',
      bad_guesses.size > 6 ? '/'   : ' ',
      bad_guesses.size > 7 ? '(_)' : head,
      bad_guesses.size > 8 ? 'jgs_|' : '____|',
    ]
  end

  def person
    head, chest, stomach, left_leg, right_leg, left_arm, right_arm, head, cc = modifications

    <<-EOF.gsub /^/, '            '

           _______
          |/      |
          |      #{head}
          |      #{left_arm}#{chest}#{right_arm}
          |       #{stomach}
          |      #{left_leg} #{right_leg}
          |
      #{cc}___

    EOF
  end

  def play?
    !won? && !lost?
  end

  def refresh_screen
    puts "\e[H\e[2J"
    puts reveal_secret_text.gsub /^/, '  '
    puts person
    p bad_guesses
    puts
  end

  def reveal_secret_text
    secret_text.split(//).collect { |letter|
      guesses.include?(letter) ? letter : "\u268b"
    }.join
  end

  def show_score
    refresh_screen
    puts won? ?
      'NEWS FLASH: Rioting in the Streets. Markets Plumet!' :
      'NEWS FLASH: Crowds Rejoice! Markets Sore!'
    puts
  end

  def wait_for_guess
    self.guesses <<  ask('Have a guess') do |q|
      q.echo      = false
      q.character = true
    end
  end

  def won?
    letters_secret_text - letters_in_guesses == []
  end
end
