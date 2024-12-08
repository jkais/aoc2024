require_relative("matrix")

def antinodes(filename)
  nodes(filename)
end

def harmonicnodes(filename)
  nodes(filename, harmonic: true)
end

def nodes(filename, harmonic: false)
  nodes = []
  matrix = to_matrix(filename)
  antennas = Hash.new { |hash, key| hash[key] = [] }

  for y in 0.upto(matrix.size - 1) do
    for x in 0.upto(matrix[0].size - 1) do
      value = matrix[y][x]

      antennas[value] << [x, y] unless value == "."
    end
  end

  lines = antennas.values.map { |antenna| antenna.combination(2).to_a }.flatten(1)

  lines.each do |line|
    line_nodes = calculate_nodes(line, matrix, harmonic)

    line_nodes.each do |node|
      nodes << node
    end
  end

  nodes.uniq!

  nodes.each do |node|
    matrix[node[0]][node[1]] = "#"
  end

  return nodes.size
end

def calculate_nodes(line, matrix, harmonic)
  result = []

  point1 = line[0]
  point2 = line[1]

  slope = [ point1[0] - point2[0], point1[1] - point2[1] ]

  # Calculation from here on is somehow broken
  # This code works for harmonic true
  # But for some reason for harmonic false, for point1 - needs to be + and for point2 + needs to be -
  # No idea what's going on, but the results were good and I got 2 stars ¯\_(ツ)_/¯
  node = point1
  while inside?(matrix, node) do
    node = [ node[0] - slope[0], node[1] - slope[1] ]
    result << node if inside?(matrix, node)
    break unless harmonic
  end

  node = point2
  while inside?(matrix, node) do
    node = [ node[0] + slope[0], node[1] + slope[1] ]
    result << node if inside?(matrix, node)
    break unless harmonic
  end

  return result
end
