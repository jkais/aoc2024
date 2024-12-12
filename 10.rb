require_relative("matrix")

def score(filename)
  result = 0

  map = Matrix.new(filename, as_integer: true)
  map.print

  for y in 0.upto(map.size_y - 1) do
    for x in 0.upto(map.size_x - 1) do
      if map.at(x, y) == 0
        result += trailhead_score(map, x, y, 0)
      end
    end
  end

  return result
end

def trailhead_score(map, x, y, current, path=[])
  return 0 if map.at(x, y) != current

  path = path.clone
  path << [x, y]

  if current == 9
    #m = Matrix.new("10/test.txt", as_integer: true)
    #path.each do |p|
    #  m.highlight(*p)
    # end
    #m.print
    puts path[0].to_s + ":" + path[9].to_s
    return 1
  end

  next_number = current += 1

  return 0 +
    trailhead_score(map, x + 1, y, next_number, path) +
    trailhead_score(map, x - 1, y, next_number, path) +
    trailhead_score(map, x, y + 1, next_number, path) +
    trailhead_score(map, x, y - 1, next_number, path)
end
