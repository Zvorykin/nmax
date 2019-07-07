# frozen_string_literal: true

require "nmax/version"

module Nmax
  INTEGERREGEXP = /\d+/.freeze

  def self.perform(stream, integers_limit = 100, char_limit = 1000)
    integers = []

    stream.each(char_limit) do |line|
      line_integers = line.scan(INTEGERREGEXP).map(&:to_i)

      next if line_integers.empty?

      integers = integers.concat(line_integers)
                         .sort
                         .take(integers_limit)
    end

    integers
  end
end
