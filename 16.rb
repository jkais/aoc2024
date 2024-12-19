require_relative("matrix")

def path(filename)
  map = Matrix.new(filename)
  x, y = map.find("S")

  path = cheapest_path(map, x, y)

  return 0
end

def cheapest_path(map, x, y, direction=:>, solutions=[], solution=[])
end

class Matrix
  def finish?(x, y)
    fx, fy = find("E")
    return fx == x && fy == y
  end
end

class Reindeer
  attr_accessor :direction

  def facing
    directions[@direction]
  end

  def directions
    {
      :> => [1, 0],
      :V => [0, 1],
      :< => [-1, 0],
      :^ => [0, -1]
    }
  end

  def left
    dirs = directions.keys
    @direction = dirs[(dirs.index(@direction)  - 1 + dirs.size) % dirs.size]
  end

  def right
    dirs = directions.keys
    @direction = dirs[(dirs.index(@direction)  +  1) % dirs.size]
  end

  def initialize(map)
  end
end
