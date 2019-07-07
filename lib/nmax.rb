# frozen_string_literal: true

require "nmax/version"

module Nmax
  INTEGER_REGEXP = /\d+/.freeze

  class MaxIntegerSearch
    attr_reader :stream, :result_limit, :line_length, :max_integers

    def initialize(stream, result_limit, line_length)
      @stream = stream
      @result_limit = result_limit || 100
      @line_length = line_length || 1000
      @max_integers = []
    end

    def perform
      stream.each(line_length) do |line|
        line_integers = string_integers(line)

        next if line_integers.empty?

        process_max_integers(line_integers)
      end

      max_integers
    end

    private

    def string_integers(string)
      string.scan(INTEGER_REGEXP).map(&:to_i)
    end

    def process_max_integers(new_integers)
      @max_integers = max_integers.concat(new_integers)
                                  .uniq
                                  .sort!

      @max_integers = max_integers.drop(result_size - result_limit) \
        if result_size > result_limit
    end

    def result_size
      max_integers.size
    end
  end
end
