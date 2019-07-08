# frozen_string_literal: true

CHARSET = Array('a'..'z') + Array(0..9) + Array(0..9) + [' ', '.', '!', '@', '#']

def generate_code(number)
  Array.new(number) { CHARSET.sample }.join
end

100_000.times { p generate_code(1_000) }