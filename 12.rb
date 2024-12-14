require_relative("matrix")

def price(filename)
  map = Matrix.new(filename)

  t = Time.now
  areas = map.areas
  puts Time.now - t
end
