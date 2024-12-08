def to_matrix(filename)
  matrix = []

  File.readlines(filename).each do |line|
    matrix << line.chomp.split("")
  end

  return matrix
end

def inside?(matrix, point)
  point[0] >= 0 && point[1] >= 0 && point[0] < matrix.size && point[1] < matrix[0].size
end

def print_matrix(matrix)
  matrix.each do |line|
    puts line.join("")
  end
end
