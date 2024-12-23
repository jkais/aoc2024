require_relative "time"

def computers(filename)
  network = File.read(filename).split("\n").map { |line| line.split("-") }.map(&:sort)
  tnetwork = network.select { |line| start_with_t?(line) }

  ts = tnetwork.flatten.uniq.select { |computer| computer.start_with?("t") }

  triangles = []

  ts.each do |t|
    connections = network.select { |line| !!line.index(t) }
    connections.permutation(2).each do |perm|
      computers = perm.flatten.select { |line| !line.index(t) }.sort
      triangles << ([t] + computers).sort if network.index(computers)
    end
    time
  end

  #sanity_check(triangles.uniq, network)

  return triangles.uniq.size
end

def start_with_t?(line)
  line.first.start_with?("t") || line.last.start_with?("t")
end

def sanity_check(triangles, network)
  triangles.each do |triangle|
    triangle.permutation(2).map(&:sort).uniq do |line|
      require "pry-byebug"; binding.pry unless !!network.index(line)
    end
    time
  end
end
