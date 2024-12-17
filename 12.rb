require_relative("matrix")

def price(filename)
  price = 0
  map = Matrix.new(filename)

  areas = map.areas

  areas.each do |area|
    price += price_for(area, map)
  end

  return price
end

def price_discount(filename)
  price = 0
  map = Matrix.new(filename)

  areas = map.areas

  areas.each do |area|
    price += price_discount_for(area, map)
  end

  return price
end

def price_discount_for(a, map)

  area = a.count
  value = map.at(*a[0])

  perimeter = 0

  # LEFT
  left_perimeters = []
  a.each do |point|
    left_perimeters << point if map.at(point[0] - 1, point[1]) != value
  end

  slices = left_perimeters.map {|p| p[0] }.uniq

  slices.each do |slice|
    pieces = left_perimeters.select { |p| p[0] == slice }.map { |p| p[1] }.sort
    previous = pieces.first

    pieces.each do |piece|
      perimeter += 1 if piece - previous != 1
      previous = piece
    end
  end

  # RIGHT
  right_perimeters = []
  a.each do |point|
    right_perimeters << point if map.at(point[0] + 1, point[1]) != value
  end

  slices = right_perimeters.map {|p| p[0] }.uniq

  slices.each do |slice|
    pieces = right_perimeters.select { |p| p[0] == slice }.map { |p| p[1] }.sort
    previous = pieces.first

    pieces.each do |piece|
      perimeter += 1 if piece - previous != 1
      previous = piece
    end
  end

  # TOP
  top_perimeters = []
  a.each do |point|
    top_perimeters << point if map.at(point[0], point[1] - 1) != value
  end

  slices = top_perimeters.map {|p| p[1] }.uniq

  slices.each do |slice|
    pieces = top_perimeters.select { |p| p[1] == slice }.map { |p| p[0] }.sort
    previous = pieces.first

    pieces.each do |piece|
      perimeter += 1 if (piece - previous != 1)
      previous = piece
    end
  end

  # BOTTOM
  bottom_perimeters = []
  a.each do |point|
    bottom_perimeters << point if map.at(point[0], point[1] + 1) != value
  end

  slices = bottom_perimeters.map {|p| p[1] }.uniq

  slices.each do |slice|
    pieces = bottom_perimeters.select { |p| p[1] == slice }.map { |p| p[0] }.sort
    previous = pieces.first

    pieces.each do |piece|
      perimeter += 1 if piece - previous != 1
      previous = piece
    end
  end

  price = area * perimeter
end

def price_for(a, map)

  area = a.count
  value = map.at(*a[0])

  perimeter = 0

  a.each do |point|
    map.neighbors(point[0], point[1], also_outside: true).each do |n|
      perimeter += 1 if map.at(*n) != value
    end
  end

  price = area * perimeter
end

class Matrix
  def areas
    a = []

    todo = generate_todo

    while (todo.flatten.any?(true))
      x, y = next_todo(todo)

      area = generate_area(x, y)
      area.each do |ax, ay|
        todo[ay][ax] = false
      end
      a << area unless a.any?(area.first)
    end

    return a
  end

  private

  def generate_todo
    Array.new(size_y) { Array.new(size_x, true) }
  end

  def generate_area(x, y, points = [])
    points << [x, y]
    neighbors(x, y).each do |neighbor|
      if at(*neighbor) == at(x, y) && !points.include?(neighbor)
        generate_area(neighbor[0], neighbor[1], points).each do |point|
          points << point unless points.include?(point)
        end
      end
    end
    return points
  end

  def next_todo(todo)
    todo.each_with_index do |row, y|
      next unless row.any?(true)
      row.each_with_index do |col, x|
       return [x, y] if !!col
      end
    end
  end
end
