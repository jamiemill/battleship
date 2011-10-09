module Jamie
  class Strategy

    BOARD_SIZE = 10

    attr_writer :state

    def get_next_shot(state, ships_remaining)
      @state = state
      @ships_remaining = ships_remaining

      #TODO: calculate impossible points and subtract from this lot
      [
        super_likely_points,
        likely_points,
        circular_seek_points,
        diagonal_seek_top_top_right_to_bottom_left,
        diagonal_seek_top_left_to_bottom_right_points,
        unknown_points
      ].inject(:+).uniq.first
    end

    def circular_seek_points
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
      points - known_points
    end

    def diagonal_seek_top_left_to_bottom_right_points
      points = []
      (0..9).each do |i|
        points.push [i,i]
      end
      points - known_points
    end

    def diagonal_seek_top_top_right_to_bottom_left
      points = []
      (0..9).each do |i|
        points.push [9-i,i]
      end
      points - known_points
    end


    def unknown_points
      points_by_type(:unknown)
    end

    def known_points
      hit_points + miss_points
    end

    def hit_points
      points_by_type(:hit)
    end

    def miss_points
      points_by_type(:miss)
    end

    def points_by_type(type)
      points = []
      @state.each_with_index do |row,y|
        row.each_with_index do |point,x|
          points.push [x,y] if point == type
        end
      end
      points
    end

    def check_point(point)
      return nil if point.nil?
      @state[point[1]][point[0]]
    end

    # Finds :unknown points immediately above, left, right, and below
    # :hit points

    def likely_points
      points = []
      hit_points.each do |point|
        points = points + around(point)
      end
      points.uniq - known_points
    end

    def in_line_with_hit_neighbours(point)
      [:up,:right,:down,:left].each do |dir|
        if check_point(self.send(dir,point)) == :hit && check_point(self.send(dir,point,2)) == :hit
          return true
        end
      end
      false
    end

    def super_likely_points
      points = likely_points.reject do |point|
        !in_line_with_hit_neighbours(point)
      end
      points.uniq - known_points
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
