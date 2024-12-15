require_relative("matrix")

def swim(filename)
  matrix, moves = File.read(filename).split("\n\n")
  map = Matrix.new(matrix.split("\n"), file: false)

  map.find_submarine

  moves = moves.gsub("\n", "").split("")

  moves.each do |direction|
   map.move direction
  end

  gps = 0

  map.matrix.each_with_index do |row, y|
    row.each_with_index do |col, x|
      gps += 100 * y + x if col == "O"
    end
  end

  return gps
end

class Matrix
  attr_reader :matrix

  def find_submarine
    @matrix.each_with_index do |row, y|
      row.each_with_index do |col, x|
        if col == "@"
          @submarine = [x,y]
        end
      end
    end
  end

  def direction(dir)
    {
      ">" => [1, 0],
      "v" => [0, 1],
      "<" => [-1, 0],
      "^" => [0, -1]
    }[dir]
  end

  def move(dir)

    set(*@submarine, ".")

    new_pos = @submarine.zip(direction(dir)).map { |a, b| a + b }
    os_pos = @submarine.zip(direction(dir)).map { |a, b| a + b }
    os = 0
    while at(*os_pos) == "O"
      os_pos = os_pos.zip(direction(dir)).map { |a, b| a + b }
    end

    if at(*os_pos) == "."
      @submarine = new_pos
      if os_pos != new_pos
        set(*os_pos, "O")
      end
    end

    set(*@submarine, "@")
    #mprint
  end

  def mprint
    puts "\e[A" * (size_y + 3)
    print
    sleep 0.01
  end
end
