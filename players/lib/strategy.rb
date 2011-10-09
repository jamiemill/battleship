module Jamie
  class Strategy

    BOARD_SIZE = 10

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


    def up(point)
      [point[0],point[1]-1]
    end

    def down(point)
      [point[0],point[1]+1]
    end

    def left(point)
      [point[0]-1,point[1]]
    end

    def right(point)
      [point[0]+1,point[1]]
    end

    def crop(point)
      range = 0...BOARD_SIZE
      if range.include? point[0] and range.include? point[1]
        point
      else
        nil
      end
    end

  end
end
