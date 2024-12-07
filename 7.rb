def calc(filename)
  calc_with_or_with_combine(filename)
end

def calc_with_combine(filename)
  calc_with_or_with_combine(filename, with_combine: true)
end

def calc_with_or_with_combine(filename, with_combine: false)
  result = 0

  equations = {}

  File.readlines(filename).each do |line|
    output, operands = line.chomp.split(": ")
    output = output.to_i

    operands = operands.split(" ").map &:to_i
    equations[output] = operands
  end

  start_time = Time.now
  equations.each do |output, operands|
    result += output_if_possible(output, operands, with_combine)
  end

  puts "Calculation took #{Time.now - start_time}s"

  return result
end

def output_if_possible(output, operands, with_combine)
  all_equations(operands, with_combine).each do |equation|
    return output if calculate(equation) == output
  end

  return 0
end

def all_equations(operands, with_combine)
  return [operands.first.to_s] if operands.length == 1

  operators = with_combine ? ["+", "*", "||"] : ["+", "*"]

  results = []
  operators.each do |operator|
    all_equations(operands[1..-1], with_combine).each do |equation|
      results << "#{operands[0]} #{operator} #{equation}"
    end
  end
  results
end

def calculate(equation)
  equation = equation.split(" ")

  result = equation.first.to_i

  i = 1
  while (i < equation.size)
    operator = equation[i]
    operand = equation[i + 1].to_i

    result += operand if operator == "+"
    result *= operand if operator == "*"
    result = (result.to_s + operand.to_s).to_i if operator == "||"

    i += 2
  end

  return result
end

