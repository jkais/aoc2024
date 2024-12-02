@advent = {
  1 => [:distance, :similarity],
}

def execute_day(day)
  require_relative("#{day}.rb")
  methods = @advent[day]

  methods.each do |method|
    puts "DAY #{day} - #{method}"
    puts "=" * (day.to_s.length + method.length + 7)
    puts
    puts "Test Data:"
    puts send(method, "#{day}/test.txt")
    puts
    puts "Real Data:"
    puts send(method, "#{day}/data.txt")
    puts
    puts
  end
end

if ARGV[0] == "all"
  @advent.keys.each do |day|
    execute_day(day)
  end
elsif ARGV[0] == "day"
  execute_day(ARGV[1].to_i)
else
  day = @advent.keys.max
  execute_day(day)
end
