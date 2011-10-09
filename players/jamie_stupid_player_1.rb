class JamieStupid1Player
  def name
    "Jamie Stupid Player 1"
  end

  def new_game
    [
      [1, 1, 3, :down],
      [6, 0, 2, :across],
      [8, 3, 5, :down],
      [2, 7, 4, :across],
      [7, 9, 3, :across]
    ]
  end

  def take_turn(state, ships_remaining)
    [rand(10), rand(10)]
  end
end
