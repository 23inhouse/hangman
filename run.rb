#!/usr/bin/env ruby

require_relative 'hangman'

secret_text = File.read(ARGV[0] || './secret_text.rb')
hangman = Hangman.new(secret_text)
hangman.play
