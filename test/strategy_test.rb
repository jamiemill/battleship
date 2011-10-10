$:.unshift File.expand_path("../../players/lib", __FILE__)

require "minitest/autorun"
require "jamie/strategy"
require "jamie/nav"
require "strategy_helper"

module Jamie

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
    assert_equal [2,1], Nav.up([2,2])
    assert_equal [2,0], Nav.up([2,2],2)
  end

  def test_down
    assert_equal [2,3], Nav.down([2,2])
  end

  def test_left
    assert_equal [1,2], Nav.left([2,2])
  end

  def test_right
    assert_equal [3,2], Nav.right([2,2])
  end

  def test_right_out_of_range
    assert_equal nil, Nav.right([9,9])
  end

  def test_crop
    assert_nil Nav.crop([-1,0])
    assert_nil Nav.crop([10,0])
    assert_nil Nav.crop([5,10])
    assert_nil Nav.crop([5,100])
    assert_equal [0,0], Nav.crop([0,0])
    assert_equal [9,9], Nav.crop([9,9])
  end

  def test_around
    assert_equal [
      [5,4],
      [6,5],
      [5,6],
      [4,5]
    ], Nav.around([5,5])
  end

  def test_around_is_cropped
    assert_equal [
      [9,8],
      [8,9]
    ], Nav.around([9,9])
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

  def test_part_of
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
    assert strategy.part_of_vertical_ship? [3,2]
    assert strategy.part_of_vertical_ship? [3,3]
    refute strategy.part_of_vertical_ship? [3,4]
    refute strategy.part_of_vertical_ship? [4,2]
    assert strategy.part_of_horizontal_ship? [9,1]
  end


  def test_adjacent_to_ships
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..........
      .......hhh
      ...h......
      ...h......
      ..........
      ..........
      ...h......
      ..........
      ..........
      ..........
    END
    )
    assert strategy.adjacent_to_ship? [2,2]
    assert strategy.adjacent_to_ship? [2,3]
    assert strategy.adjacent_to_ship? [4,2]
    assert strategy.adjacent_to_ship? [4,3]
    refute strategy.adjacent_to_ship? [4,6]
  end

  def test_not_so_likely_points
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      ..........
      .......hhh
      ...h......
      ...h......
      ..........
      ..........
      ...h......
      ..........
      ..........
      ..........
    END
    )
    result = strategy.not_so_likely_points.sort
    expected = [
      [7,0],
      [8,0],
      [9,0],

      [7,2],
      [8,2],
      [9,2],

      [2,2],
      [2,3],

      [4,2],
      [4,3],
    ].sort
    assert_equal expected, result


  end

  def test_part_of_max_unknown_line
    strategy = Jamie::Strategy.new
    strategy.state = Jamie::StrategyHelper.str_to_state(<<-END
      .m........
      mm........
      ..........
      ..m.......
      .m.m......
      .m.m......
      ..m.......
      ..........
      ..........
      ..........
    END
    )
    assert_equal 1, strategy.part_of_max_unknown_line([0,0])
    assert_equal 2, strategy.part_of_max_unknown_line([2,4])
    assert_equal 2, strategy.part_of_max_unknown_line([2,5])
  end

end

end
