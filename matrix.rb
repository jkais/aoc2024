require "rainbow"

class Matrix
  def initialize(data, as_integer: false, file: true)
    @matrix = []
    (file ? File.readlines(data) : data).each do |line|
      if as_integer
        @matrix << line.chomp.split("").map(&:to_i)
      else
        @matrix << line.chomp.split("")
      end
    end
  end

  def set_matrix(m)
    @matrix = m
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

  def print(matrix = nil, highlight: nil)
    y_size = size_y.to_s.size
    matrix ||= @matrix
    puts "".rjust(y_size) + " | " + (0..(matrix[0].size - 1)).to_a.join(" ")
    puts "-".rjust(y_size, "-") + + "-" * (2 + matrix[0].size * 2)
    matrix.each_with_index do |line, index|
      if highlight && highlight[1] == index
        line = line.dup
        line[highlight[0]] = Rainbow(line[highlight[0]]).red
      end
      puts index.to_s.rjust(y_size) + " | " + line.join(" ")
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

  def find(value)
    @matrix.each_with_index do |row, y|
      row.each_with_index do |col, x|
        return [x, y] if col == value
      end
    end
    return [nil, nil]
  end

  def size_y
    @matrix.size
  end

  def size_x
    @matrix[0].size
  end

  private
end

def time
  puts "Took " + (Time.now - @time).to_s + "s"
end

def reset
  @time = Time.now
end

reset
