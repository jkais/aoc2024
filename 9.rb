def checksum(filename)
  return "-"
  content = File.read(filename)
  filesystem = generate_filesystem(content)
  defragged = defrag(filesystem)
  return generate_checksum(defragged)
end

def checksum2(filename)
  content = File.read(filename)
  filesystem = generate_filesystem(content)
  defragged = defrag2(filesystem)
  return generate_checksum(defragged)
end

def generate_filesystem(content)
  result = []

  i = 0
  while(i < content.size)
    id = i/2

    content[i].to_i.times do
      result << id.to_s
    end

    content[i + 1].to_i.times do
      result << "."
    end

    i += 2
  end

  return result
end

def defrag(filesystem)
  while(filesystem.include?("."))
    number = filesystem.pop
    index = filesystem.index(".")
    filesystem[index] = number
  end

  return filesystem
end

def defrag2(filesystem)
  last_name = filesystem.select { |e| e != "." }.last

  start_time = Time.now
  last_name.to_i.downto(0) do |file|
    puts "Defragging " + file.to_s + "..." + "Took " + (Time.now - start_time).to_s + "s"
    size = filesystem.count(file.to_s)
    pos = find_dots(filesystem, size)

    if pos != -1 && pos < filesystem.index(file.to_s)
      filesystem.map! { |e| e == file.to_s ? "." : e }

      pos.upto(pos + size - 1) do |index|
        filesystem[index] = file.to_s
      end
    end
  end

  return filesystem
end

def generate_checksum(filesystem)
  result = 0

  filesystem.map(&:to_i).each_with_index do |num, index|
    result += num * index
  end

  return result
end

def find_dots(array, amount)
  dots = 0
  array.each_with_index do |e, index|
    if e == "."
      dots += 1
      if dots == amount
        return index - amount + 1
      end
    else
      dots = 0
    end
  end
  return -1
end
