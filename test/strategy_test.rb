require "minitest/autorun"
require "./players/lib/jamie/strategy"
require "./test/strategy_helper"

class StrategyTest < MiniTest::Unit::TestCase

  def test_str_to_state

    str = <<-END
      .mmmmmmmmm
      hmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
      mmmmmmmmmm
    END

    expected = [
      [:unknown,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:hit,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss],
      [:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss,:miss]
    ]

    assert_equal expected, Jamie::StrategyHelper.str_to_state(str)

  end

  def test_unknown_points
    strategy = Jamie::Strategy.new

    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      .mhmhmhmhm
      m.mmmmmhhh
      hmmmmhhhmm
      hhhhhhhhhh
      hhhhhhhhhh
      hhhhhhhhhh
      hhhhhhhhhh
      hhhhhhhhhh
      hhhhhhhhhh
      hh.hhhhhhh
    END
    )
    result = strategy.unknown_points
    expected = [[0,0],[1,1],[2,9]]
    assert_equal expected, result
  end

  def test_check_point
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..m.......
      m.........
      ...h......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    result = strategy.check_point([0, 0])
    expected = :unknown
    assert_equal expected, result

    result = strategy.check_point([0, 1])
    expected = :miss
    assert_equal expected, result

    result = strategy.check_point([2, 0])
    expected = :miss
    assert_equal expected, result

    result = strategy.check_point([3, 2])
    expected = :hit
    assert_equal expected, result

  end

  def test_up
    strategy = Jamie::Strategy.new
    assert_equal [2,1], strategy.up([2,2])
    assert_equal [2,0], strategy.up([2,2],2)
  end

  def test_down
    strategy = Jamie::Strategy.new
    assert_equal [2,3], strategy.down([2,2])
  end

  def test_left
    strategy = Jamie::Strategy.new
    assert_equal [1,2], strategy.left([2,2])
  end

  def test_right
    strategy = Jamie::Strategy.new
    assert_equal [3,2], strategy.right([2,2])
  end

  def test_right_out_of_range
    strategy = Jamie::Strategy.new
    assert_equal nil, strategy.right([9,9])
  end

  def test_crop
    strategy = Jamie::Strategy.new
    assert_nil strategy.crop([-1,0])
    assert_nil strategy.crop([10,0])
    assert_nil strategy.crop([5,10])
    assert_nil strategy.crop([5,100])
    assert_equal [0,0], strategy.crop([0,0])
    assert_equal [9,9], strategy.crop([9,9])
  end

  def test_around
    strategy = Jamie::Strategy.new
    assert_equal [
      [5,4],
      [6,5],
      [5,6],
      [4,5]
    ], strategy.around([5,5])
  end

  def test_around_is_cropped
    strategy = Jamie::Strategy.new
    assert_equal [
      [9,8],
      [8,9]
    ], strategy.around([9,9])
  end

  def test_likely_points
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..........
      ..........
      ...h......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    result = strategy.likely_points
    expected = [
      [3,1],
      [4,2],
      [3,3],
      [2,2]
    ]
    assert_equal expected, result
  end

  def test_likely_points_is_cropped
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ...h......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    result = strategy.likely_points
    expected = [
      [4,0],
      [3,1],
      [2,0]
    ]
    assert_equal expected, result
  end

  def test_likely_points_excludes_missed_and_hit
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..hh......
      ..mm......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    result = strategy.likely_points
    expected = [
      [1,0],
      [4,0]
    ]
    assert_equal expected, result
  end

  def test_in_line_with_hit_neighbours
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..........
      .......hhh
      ...h......
      ...h......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    assert strategy.in_line_with_hit_neighbours([3,1])
    assert strategy.in_line_with_hit_neighbours([3,4])
    assert strategy.in_line_with_hit_neighbours([6,1])

    refute strategy.in_line_with_hit_neighbours([9,9])
  end

  def test_super_likely_points
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..........
      .......hhh
      ...h......
      ...h......
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
    END
    )
    result = strategy.super_likely_points
    expected = [
      [6,1],
      [3,1],
      [3,4]
    ]
    assert_equal expected, result
  end



end

