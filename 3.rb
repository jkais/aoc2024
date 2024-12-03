def mult(filename)
  result = 0

  content = File.read(filename)
  matches = content.scan(/mul\(\d+,\d+\)/)

  matches.each do |match|
    numbers = match.scan(/\d+/).map(&:to_i)
    result += numbers[0] * numbers[1]
  end

  return result
end

def mult_with_do(filename)
  result = 0

  content = File.read(filename)

  matches = content.scan(/mul\(\d+,\d+\)|don't\(\)|do\(\)/)

  on = true

  matches.each do |match|
    if match == "don't()"
      on = false
    elsif match == "do()"
      on = true
    else
      if on
        numbers = match.scan(/\d+/).map(&:to_i)
        result += numbers[0] * numbers[1]
      end
    end
  end

  return result
end
