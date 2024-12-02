def distance(filename)
  first = []
  second = []

  File.readlines(filename).each do |line|
    a, b = line.chomp.split("  ").map &:to_i
    first << a
    second << b
  end

  first.sort!
  second.sort!

  result = 0

  first.zip(second) do |a, b|
    result += (a - b).abs
  end

  return result
end

def similarity(filename)
  first = []
  second = []
  score = 0

  File.readlines(filename).each do |line|
    a, b = line.chomp.split("  ").map &:to_i
    first << a
    second << b
  end

  first.each do |element|
    score += element * second.count(element)
  end

  return score
end
