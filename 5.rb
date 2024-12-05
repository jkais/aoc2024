def print_correct(filename)
  result = 0

  rules, manuals = parse(filename)

  manuals.each do |manual|
    result += middle_page(manual) if correct?(manual, rules)
  end

  return result
end

def print_incorrect(filename)
  result = 0

  rules, manuals = parse(filename)

  manuals.each do |manual|
    result += middle_page(sorted(manual, rules)) if !correct?(manual, rules)
  end

  return result
end

def correct?(manual, rules)
  correct = true
  rules.each do |rule|
    if manual.include?(rule[0]) && manual.include?(rule[1])
      correct = false if manual.index(rule[0]) > manual.index(rule[1])
    end
  end
  return correct
end

def sorted(manual, rules)
  while(!correct?(manual, rules)) do
    broken_rules = []
    rules.each do |rule|
      if manual.include?(rule[0]) && manual.include?(rule[1])
        broken_rules << rule if manual.index(rule[0]) > manual.index(rule[1])
      end
    end

    broken_rules.shuffle.each do |rule|
      element = rule[0]
      first_pos = manual.index(rule[0])
      second_pos = manual.index(rule[1])
      manual.delete_at(first_pos)
      manual.insert(second_pos, element)
    end
  end

  return manual
end

def middle_page(manual)
  return manual[manual.size / 2]
end

def parse(filename)
  rules = []
  manuals = []

  File.readlines(filename).each do |line|
    line.chomp!

    if line.include?("|")
      rules << line.split("|").map(&:to_i)
    end

    if line.include?(",")
      manuals << line.split(",").map(&:to_i)
    end
  end

  return rules, manuals
end
