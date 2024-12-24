require_relative "matrix"

def sequence25(filename)
  result = 0
  numpad = Numpad.new
  controlpad = Controlpad.new

  codes = File.read(filename).split("\n").map { |code| code.split("") }

  codes.each do |code|
    numpad.reset!
    code.each do |char|
      numpad.press char
    end

    solutions = solutions_for(numpad.log)

    new_solutions = []

   2.times do |i|
      solutions.each do |solution|
        new_solutions = []
        controlpad.reset!

        solution.each do |char|
          controlpad.press char
        end

        new_solutions << controlpad.log
      end
      solutions = new_solutions
    end

    solution = solutions.sort {|s| s.size }.first.join("")
    puts code.join("") + ": " + solution

    min = solutions.map(&:size).min
    time

    result += min * code.join("").to_i
  end

  return result
end

def sequence(filename)
  return 0
  result = 0
  numpad = Numpad.new
  controlpad = Controlpad.new

  codes = File.read(filename).split("\n").map { |code| code.split("") }

  codes.each do |code|
    numpad.reset!
    code.each do |char|
      numpad.press char
    end

    numpad_solutions = solutions_for(numpad.log)

    solutions = []

    numpad_solutions.each do |num|
      controlpad.reset!

      num.each do |char|
        controlpad.press char
      end

      c1_solutions = solutions_for(controlpad.log)

      c1_solutions.each do |cont|
        controlpad.reset!

        cont.each do |char|
          controlpad.press char
        end

        solutions_for(controlpad.log).each do |s|
          solutions << s
        end
      end

    end

    solution = solutions.sort {|s| s.size }.first.join("")

    min = solutions.map(&:size).min
    time

    result += min * code.join("").to_i
  end

  return result

end

def solutions_for(log)
  solutions = [[]]

  log.each do |entry|
    if entry.is_a? Array
      solutions = solutions.product(entry).map { |a, b| a + b }
    else
      solutions.each do |solution|
        solution << entry
      end
    end
  end

  return solutions
end

class Pad
  attr_accessor :matrix, :log

  def initialize
    @matrix = Matrix.new(input.split("\n"), file: false)
    reset!
  end

  def reset!
    @x, @y = matrix.find("A")
    @log = []
  end

  def press(key)
    x, y = matrix.find(key)
    moves = moves_for(x, y)

    if moves.size == 1
      moves.flatten.each do |move|
        @log << move
      end
    else
      @log << moves
    end
    @log << "A"

    @x, @y = x, y
  end

  def print
    matrix.print(highlight: [@x, @y])
    puts "Log: #{@log}"
    puts
  end

  def process(code)
    result = ""
    reset!
    code.split("").each do |move|
      puts move
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
      when " "
        print
        exit!
      end
      print
    end

    return result
  end

  private

  def moves_for(x, y)
    dx = x - @x
    dy = y - @y

    directions = []

    dx.abs.times do
      directions << [dx <=> 0, 0]
    end

    dy.abs.times do
      directions << [0, dy <=> 0]
    end

    possible_moves = directions.permutation(directions.size).to_a.uniq

    # remove all moves that go over the gap
    possible_moves.select! { |m| not_over_gap? m }

    result = possible_moves.map { |m|
      m.map { |point|
        case point
        when [1, 0]
          ">"
        when [-1,0]
          "<"
        when [0,1]
          "v"
        when [0,-1]
          "^"
        end
      }
    }

    return result
  end

  def not_over_gap?(moves)
    new_x = @x
    new_y = @y

    moves.each do |move|
      new_x += move[0]
      new_y += move[1]
      return false if matrix.at(new_x, new_y) == " "
    end

    return true
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
  def press(key)
    x, y = matrix.find(key)
    moves = moves_for(x, y)

    moves.flatten.each do |move|
      @log << move
    end

    @x, @y = x, y
  end

  private

  def moves_for(x, y)
    at = matrix.at(@x, @y)
    key = matrix.at(x, y)

    sequence =
      case at
      when "^"
        move_from_up(key)
      when "A"
        move_from_A(key)
      when "<"
        move_from_left(key)
      when "v"
        move_from_down(key)
      when ">"
        move_from_right(key)
      end.split("")

    sequence.each do |s|
      @log << s
    end
  end

  def move_from_up(key)
    case key
    when "^"
      "^A"
    when "A"
      ">A"
    when "<"
      "v<A"
    when "v"
      "vA"
    when ">"
      "v>A"
    end
  end

  def move_from_A(key)
    case key
    when "^"
      "^A"
    when "A"
      "A"
    when "<"
      "v<<A"
    when "v"
      "v<A"
    when ">"
      "vA"
    end
  end

  def move_from_left(key)
    case key
    when "^"
      ">^A"
    when "A"
      ">>^A"
    when "<"
      "A"
    when "v"
      ">A"
    when ">"
      ">>A"
    end
  end

  def move_from_down(key)
    case key
    when "^"
      "^A"
    when "A"
      ">^A"
    when "<"
      "<A"
    when "v"
      "A"
    when ">"
      ">A"
    end
  end

  def move_from_right(key)
    case key
    when "^"
      "<^A"
    when "A"
      "^A"
    when "<"
      "<<A"
    when "v"
      "<A"
    when ">"
      "A"
    end
  end

  def input
    <<~HEREDOC
     ^A
    <v>
    HEREDOC
  end
end
