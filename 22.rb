require_relative "time"

def price(filename)
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
