module Jamie
  class Strategy
    def get_next_shot(state, ships_remaining)
      [9,9]
    end

    def impossible_points(state, ships_remaining)

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

  end
end
