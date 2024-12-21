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

def check_numpad(input, code)
  controls = Numpad.new.process input
  controls == code
end

def check_input(input, code)
  controlpad = Controlpad.new
  numpad = Numpad.new
  controls = controlpad.process input
  controls = controlpad.process controls
  controls = numpad.process controls
  controls == code
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
    moves = moves_for(x,y)

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
    puts
    puts "Log: #{@log}"
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
      when " "
        print
        exit!
      end
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
  private

  def input
    <<~HEREDOC
     ^A
    <v>
    HEREDOC
  end
end
