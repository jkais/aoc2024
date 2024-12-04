def find_xmas(filename)
  result = 0

  matrix = []

  File.readlines(filename).each do |line|
    matrix << line.chomp.split("")
  end

  for x in 0.upto(matrix.size - 1) do
    for y in 0.upto(matrix.size - 1) do
      result += xmas_at(matrix, x, y)
    end
  end

  return result
end

def xmas_at(matrix, x, y)
  count = 0

  return 0 if letter_at(matrix, x, y) != "X"

  #left
  if letter_at(matrix, x, y - 1) == "M" &&
     letter_at(matrix, x, y - 2) == "A" &&
     letter_at(matrix, x, y - 3) == "S"
    count += 1
  end

  #right
  if letter_at(matrix, x, y + 1) == "M" &&
     letter_at(matrix, x, y + 2) == "A" &&
     letter_at(matrix, x, y + 3) == "S"
    count += 1
  end

  #up
  if letter_at(matrix, x - 1, y) == "M" &&
     letter_at(matrix, x - 2, y) == "A" &&
     letter_at(matrix, x - 3, y) == "S"
    count += 1
  end

  #down
  if letter_at(matrix, x + 1, y) == "M" &&
     letter_at(matrix, x + 2, y) == "A" &&
     letter_at(matrix, x + 3, y) == "S"
    count += 1
  end

  #top left
  if letter_at(matrix, x - 1, y - 1) == "M" &&
     letter_at(matrix, x - 2, y - 2) == "A" &&
     letter_at(matrix, x - 3, y - 3) == "S"
    count += 1
  end

  #top right
  if letter_at(matrix, x + 1, y - 1) == "M" &&
     letter_at(matrix, x + 2, y - 2) == "A" &&
     letter_at(matrix, x + 3, y - 3) == "S"
    count += 1
  end

  #bottom left
  if letter_at(matrix, x - 1, y + 1) == "M" &&
     letter_at(matrix, x - 2, y + 2) == "A" &&
     letter_at(matrix, x - 3, y + 3) == "S"
    count += 1
  end

  #bottom right
  if letter_at(matrix, x + 1, y + 1) == "M" &&
     letter_at(matrix, x + 2, y + 2) == "A" &&
     letter_at(matrix, x + 3, y + 3) == "S"
    count += 1
  end

  return count
end

def letter_at(matrix, x, y)
  return "" if x < 0 || y < 0 || x > matrix.size - 1 || y > matrix.size - 1
  matrix[x][y]
end

def find_mas(filename)
  result = 0

  matrix = []

  File.readlines(filename).each do |line|
    matrix << line.chomp.split("")
  end

  for x in 0.upto(matrix.size - 1) do
    for y in 0.upto(matrix.size - 1) do
      result += mas_at(matrix, x, y)
    end
  end

  return result
end

def mas_at(matrix, x, y)
  return 0 if letter_at(matrix, x, y) != "A"

  if letter_at(matrix, x - 1, y - 1) == "M" &&
     letter_at(matrix, x - 1, y + 1) == "M" &&
     letter_at(matrix, x + 1, y + 1) == "S" &&
     letter_at(matrix, x + 1, y - 1) == "S"
    return 1
  end

  if letter_at(matrix, x - 1, y - 1) == "S" &&
     letter_at(matrix, x - 1, y + 1) == "M" &&
     letter_at(matrix, x + 1, y + 1) == "M" &&
     letter_at(matrix, x + 1, y - 1) == "S"
    return 1
  end

  if letter_at(matrix, x - 1, y - 1) == "S" &&
     letter_at(matrix, x - 1, y + 1) == "S" &&
     letter_at(matrix, x + 1, y + 1) == "M" &&
     letter_at(matrix, x + 1, y - 1) == "M"
    return 1
  end

  if letter_at(matrix, x - 1, y - 1) == "M" &&
     letter_at(matrix, x - 1, y + 1) == "S" &&
     letter_at(matrix, x + 1, y + 1) == "S" &&
     letter_at(matrix, x + 1, y - 1) == "M"
    return 1
  end

  return 0
end
