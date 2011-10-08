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

  def test_impossible_points
    strategy = Jamie::Strategy.new

    state = Jamie::StrategyHelper.str_to_state(<<-END
      .m........
      m.........
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

    ships_remaining = [5, 4, 3, 3, 2]

    result = strategy.impossible_points state, ships_remaining
    expected = [[0,0]]
    #assert_equal expected, result
  end

end

