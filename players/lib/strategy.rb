module Jamie
  class Strategy

    BOARD_SIZE = 10

    def get_next_shot(state, ships_remaining)
      (
        likely_points(state) + unknown_points(state)
      ).uniq.first
    end

    def unknown_points(state)
      points_by_type(:unknown,state)
    end

    def hit_points(state)
      points_by_type(:hit,state)
    end

    def miss_points(state)
      points_by_type(:miss,state)
    end

    def points_by_type(type,state)
      points = []
      state.each_with_index do |row,y|
        row.each_with_index do |point,x|
          points.push [x,y] if point == type
        end
      end
      points
    end

    def check_point(state, x, y)
      state[y][x]
    end

    # Finds :unknown points immediately above, left, right, and below
    # :hit points

    def likely_points(state)
      points = []
      hit_points(state).each do |point|
        points = points + around(point)
      end
      points.uniq - hit_points(state) - miss_points(state)
    end

    def around(point)
      points = []
      points.push up(point)
      points.push right(point)
      points.push down(point)
      points.push left(point)
      points.reject {|p| p.nil?}
    end

    def up(point)
      crop [point[0],point[1]-1]
    end

    def down(point)
      crop [point[0],point[1]+1]
    end

    def left(point)
      crop [point[0]-1,point[1]]
    end

    def right(point)
      crop [point[0]+1,point[1]]
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
