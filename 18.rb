require_relative("matrix")

def safe(filename)
  if filename == "18/test.txt"
    size = 7
    bits = 12
  else
    size = 71
    bits = 1024
  end
  matrix = Array.new(size) { Array.new(size, ".") }
  map = Matrix.new([], file: false)
  map.set_matrix(matrix)

  File.readlines(filename).each_with_index do |line, i|
    break if i > (bits - 1)
    x, y = line.chomp.split(",").map &:to_i
    map.set(x, y, "#")
  end

  map.print

  return 0
end
