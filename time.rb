def time
  puts "Took " + (Time.now - @time).to_s + "s"
end

def reset
  @time = Time.now
end

reset
