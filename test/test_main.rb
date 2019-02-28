# frozen_string_literal: true

require 'test/unit'

class TestMain < Test::Unit::TestCase
  test 'total_structured' do
    assert_equal 13, total_structured
  end

  test 'total_functional' do
    assert_equal 13, total_functional
  end
end

def total_structured
  total = 0
  prices = [1, 5, 7]

  for n in 0..prices.length-1 do
    total = total + prices[n]
  end

  total
end

def total_functional
  total = 0
  prices = [1, 5, 7]
  prices.reduce { |total, n| total + n }
end
