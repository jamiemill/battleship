module Jamie
  module SeekStrategies

    class CircularSweep
      def self.points
        [
          # across, one space from top
          [1,1],[3,1],[5,1],[7,1],
          # down, one space from right
          [8,2],[8,4],[8,6],[8,8],
          # across left, one space from bottom
          [6,8],[4,8],[2,8],
          # up, one space from left
          [1,7],[1,5],[1,3],
        ]
      end
    end

    class DiagonalTLtoBR
      def self.points
        points = []
        (0..9).each do |i|
          points.push [i,i]
        end
        points
      end
    end

    class DiagonalTRtoBL
      def self.points
        points = []
        (0..9).each do |i|
          points.push [9-i,i]
        end
        points
      end
    end

  end
end
