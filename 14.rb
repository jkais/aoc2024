require_relative("matrix")

def robots(filename)
  if filename == "14/test.txt"
    x = 11
    y = 7
  else
    x = 101
    y = 103
  end

  matrix = Array.new(y) { Array.new(x, 0) }

  map = Matrix.new([], file: false)
  map.set_matrix(matrix)

  bots = File.read(filename).split("\n").map { |bot| Bot.new(bot, x, y) }

  100.times do
    bots.map &:move
  end

  bots.each do |bot|
    map.set(bot.px, bot.py, (map.at(bot.px, bot.py) + 1))
  end

  first = 0
  for cy in 0.upto(y/2  - 1) do
    for cx in 0.upto(x/2 - 1) do
      first += map.at(cx, cy)
    end
  end

  second = 0
  for cy in 0.upto(y/2 - 1) do
    for cx  in (x/2 + 1).upto(x-1) do
      second += map.at(cx, cy)
    end
  end

  third = 0
  for cy in (y/2 + 1).upto(y-1) do
    for cx in 0.upto(x/2 - 1) do
      third += map.at(cx, cy)
    end
  end

  fourth = 0
  for cy in (y/2 + 1).upto(y-1) do
    for cx  in (x/2 + 1).upto(x-1) do
      fourth += map.at(cx, cy)
    end
  end

  score = first * second * third * fourth

  return score
end

class Bot
  attr_reader :px, :py

  def initialize(data, x, y)
    @x = x
    @y = y

    if match = data.match(/p=(\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
      @px, @py = match[1].to_i, match[2].to_i
      @vx, @vy = match[3].to_i, match[4].to_i
    end
  end

  def move
    @px = (@px + @vx + @x) % @x
    @py = (@py + @vy + @y) % @y
  end

  def print
    puts "BOT #{@px}:#{@py} (v: #{@vx}:#{@vy}) (max: #{@x} #{@y}"
  end
end
