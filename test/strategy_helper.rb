module Jamie
  module StrategyHelper

    def self.str_to_state(str)
      subs = {
        '.' => :unknown,
        'm' => :miss,
        'h' => :hit
      }
      out = []
      str.each_line do |line|
        row = 
        line.strip.split(//).map do |char|
          subs[char]
        end
        out.push row
      end
      out
    end

  end
end
