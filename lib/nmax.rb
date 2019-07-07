# frozen_string_literal: true

require "nmax/version"

module Nmax
  INTEGER_REGEXP = /\d+/.freeze

  class << self
    def perform(stream, integers_limit = 100, char_limit = 1000)
      max_integers = []

      stream.each(char_limit) do |line|
        line_integers = string_integers(line)

        next if line_integers.empty?

        max_integers = process_max_integers(max_integers, line_integers, integers_limit)
      end

      max_integers
    end

    private

    def string_integers(string)
      string.scan(INTEGER_REGEXP).map(&:to_i)
    end

    def process_max_integers(existing_integers, new_integers, limit)
      existing_integers = existing_integers.concat(new_integers)
                            .uniq
                            .sort!

      new_size = existing_integers.size
      existing_integers = existing_integers.drop(new_size - limit) if new_size > limit

      existing_integers
    end
  end
end
