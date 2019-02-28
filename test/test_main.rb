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

  sub_test_case 'イテレータ' do
    test '繰り返しの処理:each' do
      $stdout = StringIO.new
      [1, 2, 3].each { |item| p item * item }
      output = $stdout.string
      assert_equal "1\n" + "4\n" + "9\n", output
    end

    test '特定の条件を満たす要素だけを配列に入れて返す:select' do
      result = [1.1, 2, 3.3, 4].select { |item| item.integer? }
      assert_equal [2, 4], result
    end

    test '特定の条件を満たさない要素だけを配列に入れて返す:reject' do
      result = [1.1, 2, 3.3, 4].reject { |item| item.integer? }
      assert_equal [1.1, 3.3], result
    end

    test '新しい要素の配列を返す:map' do
      result = ["apple", "orange", "pineapple", "strawberry"].map { |item| item.size }
      assert_equal [5, 6, 9, 10], result
    end

    test '新しい要素の配列を返す:collect' do
      result = ["apple", "orange", "pineapple", "strawberry"].collect { |item| item.size }
      assert_equal [5, 6, 9, 10], result
    end

    test '配列の中から、条件に一致する要素を取得する:find' do
      result = ["apple", "orange", "pineapple", "strawberry"].find { |item| item.size }
      assert_equal "apple", result
    end

    test '指定した評価式で並び変えた配列を返す:sort' do
      assert_equal ["1", "10", "13", "2", "3", "4"], ["2", "4", "13", "3", "1", "10"].sort
      assert_equal ["1", "2", "3", "4", "10", "13"], ["2", "4", "13", "3", "1", "10"].sort { |a,b| a.to_i <=> b.to_i }
      assert_equal ["13", "10", "4", "3", "2", "1"], ["2", "4", "13", "3", "1", "10"].sort { |b,a| a.to_i <=> b.to_i }
    end

    test '配列の中から、条件に一致する要素を取得する:grep' do
      result = ["apple", "orange", "pineapple", "strawberry", "apricot"].grep( /^a/)
      assert_equal ["apple", "apricot"], result
    end

    test 'ブロック内の条件式が真である間までの要素を返す:take_while' do
      result = [1,2,3,4,5,6,7,8,9].take_while { |item| item < 6 }
      assert_equal [1,2,3,4,5], result
    end

    test 'ブロック内の条件式が真である以降の要素を返す:drop_while' do
      result = [1,2,3,4,5,6,7,8,9,10].drop_while { |item| item < 6 }
      assert_equal [6,7,8,9,10], result
    end
  end

  test 'yield関数でオリジナルの関数を作成' do
    def arg_one
      yield 1
    end

    result = arg_one {|x| x + 3}
    assert_equal 4, result
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
