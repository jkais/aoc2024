class Guard
  attr_reader :position, :direction

  def initialize(position)
    @direction = :up
    @position = position
    @orig_pos_y = position[0]
    @orig_pos_x = position[1]
  end

  def reset!
    @direction = :up
    @position = [@orig_pos_y, @orig_pos_x]
  end

  def rotate
    @direction = case @direction
                 when :up
                   :right
                 when :right
                   :down
                 when :down
                   :left
                 when :left
                   :up
                 end
  end

  def move
    case @direction
    when :up
      @position[0] -= 1
    when :right
      @position[1] += 1
    when :down
      @position[0] += 1
    when :left
      @position[1] -= 1
    end
  end

  def next_pos
    pos = @position.clone
    case @direction
    when :up
      pos[0] -= 1
    when :right
      pos[1] += 1
    when :down
      pos[0] += 1
    when :left
      pos[1] -= 1
    end

    return pos
  end
end

class Maze
  attr_accessor :maze
  attr_reader :guard

  def initialize(filename, circle_tracking = false)
    @maze = []
    @circle_tracking = circle_tracking

    File.readlines(filename).each do |line|
      @maze << line.chomp.split("")
    end

    for y in 0.upto(@maze.size - 1) do
      for x in 0.upto(@maze[y].size - 1) do
        @guard = Guard.new([y, x]) if @maze[y][x] == "^"
      end
    end
  end

  def move_guard
    mark_pos
    @guard.move
  end

  def obstacle_ahead?
    return false if !ahead_in_maze?
    at(guard.next_pos[0], guard.next_pos[1]) == "#"
  end

  def guard_in_maze?
    position_in_maze?(guard.position[0], guard.position[1])
  end

  def run_in_circle?
    guard_in_maze? && at(guard.position[0], guard.position[1]) == @guard.direction[0]
  end

  def ahead_in_maze?
    position_in_maze?(guard.next_pos[0], guard.next_pos[1])
  end

  def mark_pos
    @maze[@guard.position[0]][@guard.position[1]] = circle_tracking? ? @guard.direction[0] : "X"
  end

  def position_in_maze?(y, x)
    y >= 0 && x >= 0 && y < @maze.size && x < @maze[0].size
  end

  def at(y, x)
    @maze[y][x]
  end

  def circle_tracking?
    !!@circle_tracking
  end

  def to_s
    @maze.map(&:join).join()
  end
end

def path(filename)
  maze = Maze.new(filename)

  while(maze.guard_in_maze?) do
    if maze.obstacle_ahead?
      maze.guard.rotate
    else
      maze.move_guard
    end
  end

  return  maze.to_s.count("X")
end


def circles(filename)
  result = 0

  maze = Maze.new(filename, circle_tracking: true)
  original = maze.maze.map(&:dup)

  start_time = Time.now

  for y in 0.upto(original.size - 1) do
    puts "Doing Line " + y.to_s
    puts "Execution Time so far: #{Time.now - start_time} seconds"
    for x in 0.upto(original[0].size - 1) do

      next unless original[y][x] == "."

      copy = original.map(&:dup)
      copy[y][x] = "#"
      maze.maze = copy
      maze.guard.reset!

      while(maze.guard_in_maze? && !maze.run_in_circle?) do
        if maze.obstacle_ahead?
          maze.guard.rotate
        else
          maze.move_guard
        end
      end

     result += 1 if maze.run_in_circle?
    end
    puts
    puts "Overall Execution Time: #{Time.now - start_time} seconds"
  end

  return result
end
