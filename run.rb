@advent = {
  1 => [:distance, :similarity],
  2 => [:safety, :more_safety],
  3 => [:mult, :mult_with_do],
  4 => [:find_xmas, :find_mas],
  5 => [:print_correct, :print_incorrect],
  6 => [:path, :circles],
  7 => [:calc, :calc_with_combine],
  8 => [:antinodes, :harmonicnodes],
  9 => [:checksum, :checksum2],
  10 => [:score],
  11 => [:blink25, :blink75],
  12 => [:price],
  13 => [:amount],
  14 => [:robots, :xmas],
  15 => [:swim],
}

def execute_day(day)
  require_relative("#{day}.rb")
  methods = @advent[day]

  methods.each do |method|
    puts "DAY #{day} - #{method}"
    puts "=" * (day.to_s.length + method.length + 7)
    puts "Test Data:"
    puts send(method, "#{day}/test.txt")
    puts
    if ARGV[0] != "test"
      puts "Real Data:"
      puts send(method, "#{day}/data.txt")
      puts
    end
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
