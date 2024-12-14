def amount(filename)
  machines = []

  content = File.read(filename)
  content.split("\n\n").each do |machine|
    values = machine.match /Button A:\s*X\+(\d+),\s*Y\+(\d+)/
    button_a = Button.new(x: values[1].to_i, y: values[2].to_i)

    values = machine.match /Button B:\s*X\+(\d+),\s*Y\+(\d+)/
    button_b = Button.new(x: values[1].to_i, y: values[2].to_i)

    values = machine.match /Prize:\s*X\=(\d+),\s*Y\=(\d+)/
    machines << Machine.new(a: button_a, b: button_b, x: values[1].to_i, y: values[2].to_i)
  end

  return machines.map(&:min_tokens).sum
end

class Machine
  attr_reader :a, :b, :x, :y

  def initialize(a:, b:, x:, y:)
    @a = a
    @b = b
    @x = x
    @y = y
  end

  def min_tokens
    hit = false

    max_button_a = [x / a.x, y / a.y].max
    max_button_b = [x / b.x, y / b.y].max

    max_button_a = 100
    max_button_b = 100

    min = max_button_a * 3 + max_button_b

    max_button_a.times do |b_a|
      max_button_b.times do |b_b|
        new_x = b_a * a.x + b_b * b.x
        new_y = b_a * a.y + b_b * b.y

        price = b_a * 3 + b_b

        if new_x == x && new_y == y && price < min
          hit = true
          min = price
        end
      end
    end

    return hit ? min : 0
  end
end

class Button
  attr_reader :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end
end
