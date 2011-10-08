module Jamie
  class Strategy
    def get_next_shot(state, ships_remaining)
      [9,9]
    end

    def impossible_points(state, ships_remaining)

    end

    def unknown_points(state)
      points = []
      y = 0
      state.each do |row|
        x  = 0
        row.each do |point|
          points.push [x,y] if point == :unknown
          x = x+1
        end
        y = y+1
      end
      points
    end

  end
end
