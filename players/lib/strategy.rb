module Jamie
  class Strategy

    BOARD_SIZE = 10

    def get_next_shot(state, ships_remaining)
      [
        likely_points(state),
        circular_seek_points(state),
        diagonal_seek_top_top_right_to_bottom_left(state),
        diagonal_seek_top_left_to_bottom_right_points(state),
        unknown_points(state)
      ].inject(:+).uniq.first
    end

    def circular_seek_points(state)
      points = [
        # across, one space from top
        [1,1],[3,1],[5,1],[7,1],
        # down, one space from right
        [8,2],[8,4],[8,6],[8,8],
        # across left, one space from bottom
        [6,8],[4,8],[2,8],
        # up, one space from left
        [1,7],[1,5],[1,3],
      ]
      points - known_points(state)
    end

    def diagonal_seek_top_left_to_bottom_right_points(state)
      points = []
      (0..9).each do |i|
        points.push [i,i]
      end
      points - known_points(state)
    end

    def diagonal_seek_top_top_right_to_bottom_left(state)
      points = []
      (0..9).each do |i|
        points.push [9-i,i]
      end
      points - known_points(state)
    end


    def unknown_points(state)
      points_by_type(:unknown,state)
    end

    def known_points(state)
      hit_points(state) + miss_points(state)
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

    def check_point(state, point)
      state[point[1]][point[0]]
    end

    # Finds :unknown points immediately above, left, right, and below
    # :hit points

    def likely_points(state)
      points = []
      hit_points(state).each do |point|
        points = points + around(point)
      end
      points.uniq - known_points(state)
    end

    def around(point)
      points = []
      points.push up(point)
      points.push right(point)
      points.push down(point)
      points.push left(point)
      points.reject {|p| p.nil?}
    end

    def up(point,dist=1)
      crop [point[0],point[1]-dist]
    end

    def down(point,dist=1)
      crop [point[0],point[1]+dist]
    end

    def left(point,dist=1)
      crop [point[0]-dist,point[1]]
    end

    def right(point,dist=1)
      crop [point[0]+dist,point[1]]
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
