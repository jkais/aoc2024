class Stone
  attr_reader :value, :changed
  def initialize(val, changed: false)
    @value = val
    @changed = changed
  end

  def set(val)
    @value = val unless changed
    @changed = true
  end

  def reset!
    @changed = false
  end

  def to_s
    "v: #{value} c: #{changed}"
  end

  def changed?
    changed
  end
end

def blink25(filename)
  blink(25, filename)
end

def blink75(filename)
  blink(75, filename)
end

def blink(blinks, filename)
  stones = File.read(filename).split(" ").map { |value| Stone.new(value.to_i) }
  puts stones.map(&:to_s)

  t = Time.now
  blinks.times do |time|
    puts time.to_s + ": " + stones.size.to_s
    puts "Time: " + (Time.now - t).to_s
    stones = blink1(stones)
  end

  return stones.size
end

def blink1(stones)
  stones.map(&:reset!)

  stones.each_with_index do |stone, i|
    if !stone.changed?
      if stone.value == 0
        stone.set(1)
      elsif stone.value.to_s.size % 2 == 0
        part1, part2 = split_string(stone.value.to_s)
        stones.delete_at(i)
        stones.insert(i, Stone.new(part2.to_i, changed: true))
        stones.insert(i, Stone.new(part1.to_i, changed: true))
      else
        stone.set(stone.value * 2024)
      end
    end
  end

  return stones
end

def split_string(str)
  half = str.length / 2
  [str[0...half], str[half..-1]]
end
