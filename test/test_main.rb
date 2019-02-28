# frozen_string_literal: true

require 'test/unit'

class TestMain < Test::Unit::TestCase
  test 'Hello, world!' do
    assert_equal 'Hello, world!', greeting
  end
end

def greeting
  'Hello, world!'
end
