require "minitest/autorun"
require "./players/lib/strategy"
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

    state = Jamie::StrategyHelper.str_to_state(<<-END
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
    result = strategy.unknown_points state
    expected = [[0,0],[1,1],[2,9]]
    assert_equal expected, result
  end

  def test_check_point
    strategy = Jamie::Strategy.new
    state = Jamie::StrategyHelper.str_to_state(<<-END
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
    result = strategy.check_point(state, 0, 0)
    expected = :unknown
    assert_equal expected, result

    result = strategy.check_point(state, 0, 1)
    expected = :miss
    assert_equal expected, result

    result = strategy.check_point(state, 2, 0)
    expected = :miss
    assert_equal expected, result

    result = strategy.check_point(state, 3, 2)
    expected = :hit
    assert_equal expected, result

  end

end

