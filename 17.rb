require 'gruff'

def run(filename)
  processor = Processor.new File.read(filename)
  return processor.output.join(",")
end

def lowest(filename)
  return if filename == "17/test.txt"
  from = 35184372088831
  to =   281844000000000

  step = [((to -from) / 1_000), 1].max
  step = 1

  from = 0
  to =   281844000000000

  processor = Processor.new File.read(filename), from
  program = processor.program.join("").to_i

  differences = []

  min = Float::INFINITY

  for a in from.step(to, step)
    processor = Processor.new File.read(filename), a
    output = processor.output.join("").to_i
    puts a.to_s + ": (" + (to - a).to_s + ") min: " + min.to_s
    difference = (program - output)
    differences << difference
    if processor.output == processor.program
      puts "FOUND: " + a
      break
    end

    min = difference.abs if difference.abs < min
  end

  puts "PROGRAM: " + program.to_s
  puts "STEP: " + step.to_s
  puts "MIN: " + min.to_s

  g = Gruff::Line.new
  g.title = "Processor"
  g.data(:Values, differences)
  g.write("0.png")
end



class Processor
  attr_reader :output, :program
  attr_accessor :a

  def opcode(id)
    [:adv, :bxl, :bst, :jnz, :bxc, :out, :bdv, :cdv][id]
  end

  def initialize(content, a=nil, debug: false)
    @debug = debug

    lines = content.split("\n")

    @a = a.nil? ? lines[0].split(" ").last.to_i : a
    @b = lines[1].split(" ").last.to_i
    @c = lines[2].split(" ").last.to_i

    @program = lines.last.split(" ").last.split(",").map(&:to_i)

    @pointer = 0
    @output = []
    print if @debug
    run
    return @output
  end

  def run
    while (@pointer < @program.size)
      calculate
      step
    end
  end

  def calculate
    opcode = opcode(@program[@pointer])
    operand = @program[@pointer + 1]
    combo = operand_value(operand)

    if @debug
      puts
      puts "#{opcode} #{operand}(=#{combo})"
      print
    end

    case opcode
    when :adv
      @a = @a / (2**combo)
    when :bxl
      @b = @b ^ operand
    when :bst
      @b = combo % 8
    when :jnz
      if @a != 0
        @no_step = true
        @pointer = operand
      end
    when :bxc
      @b = @b ^ @c
    when :out
      @output << combo % 8
    when :bdv
      @b = @a / (2**combo)
    when :cdv
      @c = @a / (2**combo)
    end
  end

  def current_opcode
    opcode(@program[@pointer])
  end

  def operand_value(operand)
    case operand
    when 4
      return @a
    when 5
      return @b
    when 6
      return @c
    else
      return operand
    end
  end

  def step
    @pointer += 2 if step?
    @no_step = false
  end

  def step?
    !@no_step
  end

  def print
    puts "Pointer: " + @pointer.to_s
    puts "A: " + @a.to_s
    puts "B: " + @b.to_s
    puts "C: " + @c.to_s
  end
end
