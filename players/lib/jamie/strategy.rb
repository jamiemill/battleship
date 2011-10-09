require 'jamie/seek_strategies'
require 'jamie/nav'
require 'jamie/state_inspections'

module Jamie
  class Strategy

    include Jamie::StateInspections

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

    # Finds :unknown points immediately above, left, right, and below
    # :hit points

    def likely_points
      points = []
      hit_points.each do |point|
        points = points + Nav.around(point)
      end
      points.uniq - known_points
    end

    def in_line_with_hit_neighbours(point)
      [:up,:right,:down,:left].each do |dir|
        if check_point(Nav.send(dir,point)) == :hit && check_point(Nav.send(dir,point,2)) == :hit
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


  end
end
