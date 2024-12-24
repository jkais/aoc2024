def time(mess="")
  t = seconds
  hours = t.to_i / 3600
  minutes = t.to_i / 60
  seconds = (t % 60).round(3)

  to_words = "#{seconds}s"
  to_words = "#{minutes}m #{to_words}" if minutes > 0
  to_words = "#{hours}h #{to_words}" if hours > 0

  first = mess == "" ? "Took" : "#{mess} took"

  puts "#{first} #{to_words}"
end

def reset
  @time = Time.now
end

def seconds
  Time.now - @time
end

reset
