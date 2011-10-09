require 'jamie/nav'

module Jamie

  module StateInspections

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

    def in_line_with_hit_neighbours?(point)
      [:up,:right,:down,:left].each do |dir|
        if check_point(Nav.send(dir,point)) == :hit && check_point(Nav.send(dir,point,2)) == :hit
          return true
        end
      end
      false
    end

  end
end
