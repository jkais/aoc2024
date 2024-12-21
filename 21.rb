require_relative "matrix"

def sequence(filename)
  result = 0
  numpad = Numpad.new
  controlpad = Controlpad.new

  codes = File.read(filename).split("\n").map { |code| code.split("") }

  codes.each do |code|
    numpad.reset!
    code.each do |char|
      numpad.press char
    end
    log = numpad.log
    2.times do
      controlpad.reset!
      log.each do |char|
        controlpad.press char
      end
      log = controlpad.log
    end
    result += log.size * code.join("").to_i
    break
  end

  #puts check_input("<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A", "179A")

  return result
end

def check_input(input, code)
  controlpad = Controlpad.new
  numpad = Numpad.new
  controls = controlpad.process input
  controls = controlpad.process controls
  controls = numpad.process controls
  controls == code
end

class Pad
  attr_accessor :matrix, :log

  def initialize
    @matrix = Matrix.new(input.split("\n"), file: false)
    reset!
  end

  def process(code)
    result = ""
    reset!
    code.split("").each do |move|
      case move
      when "<"
        @x = @x - 1
      when ">"
        @x = @x + 1
      when "^"
        @y = @y - 1
      when "v"
        @y = @y + 1
      when "A"
        result += matrix.at(@x,@y)
      end
    end

    return result
  end

  def reset!
    @x, @y = matrix.find("A")
    @log = []
  end

  def press(key)
    x, y = matrix.find(key)
    @log << moves_for(x, y)
    @log.flatten!

    @x, @y = x, y
  end

  def print
    matrix.print(highlight: [@x, @y])
    puts
    puts "Log: #{@log}"
  end

  private

  def moves_for(x, y)
    moves = []
    dx = @x - x
    dy = @y - y
    moves << ((dx > 0) ? "<"*dx.abs : ">"*dx.abs).split("")
    moves << ((dy > 0) ? "^"*dy.abs : "v"*dy.abs).split("")
    moves << "A"

    moves.flatten!
  end
end

class Numpad < Pad
  private

  def input
    <<~HEREDOC
    789
    456
    123
     0A
    HEREDOC
  end
end

class Controlpad < Pad
  private

  def input
    <<~HEREDOC
     ^A
    <v>
    HEREDOC
  end
end
