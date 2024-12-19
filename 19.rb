require "rainbow"

def towels(filename)
  towels, combinations = File.read(filename).split("\n\n")

  towels = towels.split(", ")
  combinations = combinations.split("\n")

  towels = towels.select { |towel| !check(towel, towels.select { |t| t != towel }) }

  correct = 0

  combinations.each_with_index do |combination, i|
    possible_towels = towels.select { |towel| combination.match towel }
    c = check(combination, possible_towels)
    print_towel(combination, c)
    correct += 1 if c
  end
  puts

  return correct
end

def check(combination, possible_towels)
  matching = false

  for i in 1.upto(combination.size) do
    return possible_towels.include?(combination) if i == combination.size

    if possible_towels.include?(combination.slice(0, i))
      matching = matching || check(combination.slice(i, combination.size - 1), possible_towels)
    end
    break if matching
  end

  return matching
end

def print_towel(towel, check)
  towel = towel.dup
  t = "\u2588"
  towel.gsub!("w", Rainbow(t).white)
  towel.gsub!("u", Rainbow(t).blue)
  towel.gsub!("b", Rainbow(t).yellow)
  towel.gsub!("r", Rainbow(t).red)
  towel.gsub!("g", Rainbow(t).green)

  puts (check ? "✅" : "❌") + " " + towel
end


