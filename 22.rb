require_relative "time"
require "parallel"

def random(filename)
  return 0
  result = 0
  secrets = File.read(filename).split("\n").map &:to_i

  secrets.each do |secret|
    2000.times do
      secret = first(secret)
      secret = second(secret)
      secret = third(secret)
    end
    time
    result += secret
  end

  return result
end

@max_bananas = 0

def price(filename)
  return if filename == "22/test.txt"
  secrets = File.read(filename).split("\n").map &:to_i

  data = []

  reset
  secrets.each do |secret|
    prices = [secret  % 10]
    2000.times do
      secret = first(secret)
      secret = second(secret)
      secret = third(secret)
      prices << secret % 10
    end

    d = {prices: prices, differences: differences = calculate_differences(prices) }
    data << d
  end

  puts "Prices and Differences generated"

  permutations = (-9..9).to_a.permutation(4)

  p = "Calculating... "
  File.truncate("bananas.txt", 0)

  results = Parallel.each_with_index(permutations, in_threasd: 10, progress: p) do |sequence, i|
    bananas = 0
    data.each do |buyer|
      index = buyer[:differences].each_cons(sequence.length).find_index(sequence)
      if index
        bananas += buyer[:prices][index + 4]
        next
      end
    end

    File.open("bananas.txt", "a") do |file|
      file.puts "#{bananas} #{sequence}"
    end if bananas > 0
  end

  return 0
end

def calculate_differences(array)
  array.each_cons(2).map { |a, b| b - a}
end

def first(number)
  result = number * 64

  result = result ^ number
  result = result % 16777216
end

def second(number)
  result = number / 32

  result = result ^ number
  result = result % 16777216
end

def third(number)
  result = number * 2048

  result = result ^ number
  result = result % 16777216
end

def read_banana_data
  max = 0
  seq = nil

  File.readlines("bananas.txt").each do |line|
    b, sq = line.chomp.split(" ", 2)
    b = b.to_i

    if b > max
      seq = sq
      max = b
    end
  end

  puts max
  puts seq
end
