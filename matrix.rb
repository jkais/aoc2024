require "rainbow"

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

  def set(x, y, value)
    @matrix[y][x] = value
  end

  def highlight(x, y)
    set(x, y, Rainbow(at(x,y)).red)
  end

  def inside?(x, y)
    x >= 0 && y >= 0 && x < size_x && y < size_y
  end

  def print(matrix = nil)
    matrix ||= @matrix
    puts "  | " + (0..(matrix[0].size - 1)).to_a.join(" ")
    puts "---" + "-" * matrix[0].size * 2
    matrix.each_with_index do |line, index|
      puts index.to_s + " | " + line.join(" ")
    end
  end

  def neighbors(x, y, also_outside: false)
    neighbors = [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1],
    ]

    return also_outside ? neighbors : neighbors.select { |point| inside?(*point) }
  end

  def size_y
    @matrix.size
  end

  def size_x
    @matrix[0].size
  end

  private
end
