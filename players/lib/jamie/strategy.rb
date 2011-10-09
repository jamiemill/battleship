require 'jamie/seek_strategies'

module Jamie
  class Strategy

    BOARD_SIZE = 10

    attr_writer :state

    def get_next_shot(state, ships_remaining)
      @state = state
      @ships_remaining = ships_remaining

      #TODO: calculate impossible points and subtract from this lot
      points_to_try = [
        super_likely_points,
        likely_points,
        SeekStrategies::CircularSweep.points,
        SeekStrategies::DiagonalTLtoBR.points,
        SeekStrategies::DiagonalTRtoBL.points,
        unknown_points
      ].inject(:+).uniq
      points_to_try = points_to_try - known_points
      points_to_try.first
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
          points << [x,y] if point == type
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
      points << up(point)
      points << right(point)
      points << down(point)
      points << left(point)
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
