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

class Matrix
  def initialize(filename, as_integer: false)
    @matrix = []
    File.readlines(filename).each do |line|
      if as_integer
        @matrix << line.chomp.split("").map(&:to_i)
      else
        @matrix << line.chomp.split("")
      end
    end
  end

  def at(x, y)
    return nil unless inside?(x, y)
    @matrix[y][x]
  end

  def inside?(x, y)
    x >= 0 && y >= 0 && x < size_x && y < size_y
  end

  def print
    puts "  | " + (0..(size_x - 1)).to_a.join(" ")
    puts "---" + "-" * size_x * 2
    @matrix.each_with_index do |line, index|
      puts index.to_s + " | " + line.join(" ")
    end
  end

  def size_y
    @matrix.size
  end

  def size_x
    @matrix[0].size
  end
end
