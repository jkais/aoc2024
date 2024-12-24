require_relative "time"

def zvalue(filename)
  circuit = Circuit.new(*File.read(filename).split("\n\n"))
  circuit.process

  return circuit.zs
end

class Gate
  attr_reader :in1, :in2, :op, :out

  def initialize(input)
    inp, @out = input.split(" -> ")

    @in1, @op, @in2 = inp.split(" ")
    @done = false
    @count = 0
  end

  def process(in1, in2)
    @count += 1
    @done = true
    case @op
    when "OR"
      return in1 || in2
    when "XOR"
      return in1 ^ in2
    when "AND"
      return in1 && in2
    end
  end

  def done?
    !!@done
  end
end

class Circuit
  attr_reader :gates, :registers

  def initialize(registers, gates)
    @registers = {}
    @gates = gates.split("\n").map { |g| Gate.new(g) }

    registers.split("\n").each do |r|
      key, value = r.split(": ")
      @registers[key] = value == "1"
    end

  end

  def process
    while(gates_to_process).any?
      gates_to_process.each do |gate|
        if @registers.keys.index(gate.in1) && @registers.keys.index(gate.in2)
          in1 = @registers[gate.in1]
          in2 = @registers[gate.in2]
          @registers[gate.out] = gate.process(in1, in2)
        end
      end
    end
  end

  def zs
    result = ""
    @registers.keys.select { |key| key.start_with?("z") }.sort.reverse.each do |key|
      result += @registers[key] ? "1" : "0"
    end
    return result.to_i(2)
  end

  def  gates_to_process
    @gates.select { |gate| !gate.done? }
  end
end
