# frozen_string_literal: true

class FakeStream
  def initialize
    @string = '0 3 5 asd 10.9.a 9 ё 122 !!1000'
  end

  def each(limit, &block)
    split_limit_regexp = /(.{#{limit}})/.freeze

    @string.split(split_limit_regexp)
           .each { |line| block.yield(line) }
  end
end
