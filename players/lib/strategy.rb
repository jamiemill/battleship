module Jamie
  class Strategy

    def get_next_shot(state, ships_remaining)
      unknown_points(state).first
    end

    def unknown_points(state)
      points = []
      state.each_with_index do |row,y|
        row.each_with_index do |point,x|
          points.push [x,y] if point == :unknown
        end
      end
      points
    end

    def check_point(state, x, y)
      state[y][x]
    end

  end
end
