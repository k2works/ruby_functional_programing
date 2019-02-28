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

  sub_test_case '関数を受ける関数の作成' do
    test 'yield関数でオリジナルの関数を作成' do
      def arg_one
        yield 1
      end
  
      result = arg_one {|x| x + 3}
      assert_equal 4, result
    end
  
    test 'yield関数でもう少し複雑な関数を定義' do
      def arg_one_twice
        yield(1) + yield(2)
      end
  
      result = arg_one_twice {|x| x + 3}
      assert_equal 9, result
    end
  
    test '関数を受け取れる関数の作成' do
      def arg_one(&block)
        block.call 1
      end
  
      result = arg_one {|x| x + 3}
      assert_equal 4, result
    end
  
    test '手続きオブジェクトとして関数を作成' do
      plusthree = Proc.new {|x| x + 3}
  
      result = plusthree.call(1)
      assert_equal 4, result
    end
  
    test 'lambdaで関数を作成' do
      plusthree = lambda {|x| x + 3}
  
      result = plusthree.call(1)
      assert_equal 4, result
    end
  
    test '引数の数の明確なチェック' do
      assert_nothing_raised do
        plusthree = Proc.new {|x| x + 3}
        plusthree.call(1,2)
      end
  
      assert_raise do
        plusthree = lambda {|x| x + 3}
        plusthree.call(1,2)
      end
    end
  end

  sub_test_case 'クロージャー' do
    test 'クロージャーの処理' do
      def multi(i)
        func = Proc.new {|x| x * 2}
        func.call(i)
      end

      assert_equal 4, multi(2)
      assert_equal 12, multi(6)
    end

    test 'Proc.newにブロックを直接指定' do
      def multi(i)
        func = Proc.new
        func.call(i)
      end

      result = multi(2) {|x|x*6}
      assert_equal 12, result

      result = multi(6) {|x|x*8}
      assert_equal 48, result

      assert_raise do
        multi(8)
      end
    end

    test '手続きオブジェクトのブロック内から外部のローカル変数を参照' do
      def count
        number = 0
        func = lambda {|i| number += i}
        func
      end

      assert_equal 1, count.call(1)
      assert_equal 2, count.call(2)
      assert_equal 3, count.call(3)
      assert_equal 4, count.call(4)
    end

    test '更新された値を保持' do
      def count
        number = 0
        func = lambda {|i| number += i}
        func
      end

      fun = count
      assert_equal 1, fun.call(1)
      assert_equal 3, fun.call(2)
      assert_equal 6, fun.call(3)
      assert_equal 10, fun.call(4)
    end

    test '変数を使用したときの振る舞いを比較1' do
      x = 1
      $stdout = StringIO.new
      func = Proc.new {|x| p x}
      func.call(3)
      p x
      
      output = $stdout.string
      assert_equal "3\n" + "1\n", output
    end

    test '変数を使用したときの振る舞いを比較2' do
      x = 1
      $stdout = StringIO.new
      func = Proc.new {|y|x=y; p x}
      func.call(3)
      p x
      
      output = $stdout.string
      assert_equal "3\n" + "3\n", output
    end

    test 'ブロックのローカル変数としての宣言' do
      x = 1
      $stdout = StringIO.new
      func = Proc.new {|y;x|x=y; p x}
      func.call(3)
      p x
      
      output = $stdout.string
      assert_equal "3\n" + "1\n", output
    end

    test '&を使った処理' do
      def block_example
        yield
      end

      func = Proc.new {'Block Example'}
      assert_equal 'Block Example', block_example(&func)
    end
  end

  sub_test_case 'ファーストクラスオブジェクト' do
    test 'lambdaを使った代入の例' do
      x = lambda { 'First Class Example' }
      assert_equal 'First Class Example', x.call
      
      y = x
      assert_equal 'First Class Example', y.call
    end

    test 'lambdaを使った引数の例' do
      x = lambda { 'First Class Example' }
      def f(x)
        x.call
      end
      
      assert_equal 'First Class Example', f(x)
    end
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
