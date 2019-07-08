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
      integer_part = nil
      found_integers = []

      stream.each(line_length) do |line|
        next if line == ''

        string_to_search = integer_part.nil? ? line : integer_part + line
        integer_part = nil

        line_integers = string_integers(string_to_search)

        next if line_integers.empty?

        if line.end_with?(line_integers.last.to_s)
          integer_part = line_integers.last.to_s
          line_integers.pop
        end

        line_integers.each { |item| found_integers << item }

        if found_integers.size >= result_limit
          process_max_integers(found_integers)
          found_integers = []
        end
      end

      found_integers << integer_part.to_i unless integer_part.nil?
      process_max_integers(found_integers) if found_integers.any?

      max_integers
    end

    private

    def string_integers(string)
      string.scan(INTEGER_REGEXP).map(&:to_i)
    end

    def process_max_integers(new_integers)
      lowest_result = max_integers.first

      new_integers.each do |item|
        max_integers << item if lowest_result.nil? || item > lowest_result
      end

      max_integers.uniq!
      max_integers.sort!

      limit_max_integers
    end

    def limit_max_integers
      return if result_size <= result_limit

      (result_size - result_limit).times { max_integers.delete_at(0) }
    end

    def result_size
      max_integers.size
    end
  end
end
