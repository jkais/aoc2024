def safety(filename)
  safe_count = 0

  File.readlines(filename).each do |line|
    safe_count += 1 if safe?(line.chomp.split(" ").map(&:to_i))
  end

  return safe_count
end

def safe?(line)
  first_diff = line[0] - line[1]
  return false if first_diff == 0
  line.reverse! if first_diff < 0

  line.each_cons(2) do |a, b|
    diff = a - b
    return false if diff <= 0 || diff > 3
  end

  return true
end

def more_safety(filename)
  safe_count = 0

  File.readlines(filename).each do |line|
    safe_count += 1 if more_safe?(line.chomp.split(" ").map(&:to_i))
  end

  return safe_count
end

def more_safe?(line)
  safe = false

  line.combination(line.size - 1).each do |combination|
    safe = safe || safe?(combination)
  end

  return safe
end
