require_relative("matrix")

def score(filename)
  result = 0

  map = Matrix.new(filename, as_integer: true)
  map.print
  return

  for y in 0.upto(map.size_y - 1) do
    for x in 0.upto(map.size_x - 1) do
      if map.at(x, y) == 0
        puts "CHECK TRAILHEAD"
        result += trailhead_score(map, y, x, 0)
      end
    end
  end

  return result
end

def trailhead_score(map, y, x, current)
  puts x.to_s + ":" + y.to_s + " = " + current.to_s
  result = 0

  if current == 9
    return 1
  end

  # try right
  if map.at(x + 1, y) == current + 1
    result += trailhead_score(map, x + 1, y, current + 1)
  end

  # try down
  if map.at(x, y + 1) == current + 1
    result += trailhead_score(map, x, y + 1, current + 1)
  end

  # try left
  if map.at(x - 1, y) == current + 1
    result += trailhead_score(map, x - 1, y, current + 1)
  end

  # try up
  if map.at(x, y - 1) == current + 1
    result += trailhead_score(map, x, y - 1, current + 1)
  end

  return result
end
