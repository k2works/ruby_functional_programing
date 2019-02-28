# frozen_string_literal: true

require 'test/unit'

class TestMain < Test::Unit::TestCase
  test 'total_structured' do
    assert_equal 13, total_structured
  end

  test 'total_functional' do
    assert_equal 13, total_functional
  end

  test 'iterator_not_using' do
    assert_equal [2, 4, 6, 8], iterator_not_using
  end

  test 'iterator_using' do
    assert_equal [2, 4, 6, 8], iterator_using_select
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

def iterator_not_using
  result = []
  for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    if i%2 == 0
      result << i
    end
  end
  result
end

def iterator_using_select
  [1, 2, 3, 4, 5, 6, 7, 8, 9].select { |i| i%2 == 0 }
end
