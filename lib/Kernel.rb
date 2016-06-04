#encoding: utf-8

module Kernel
  C1 = "\""
  C2 = " "
  def parse_command(string)
    command = []
    i = nil
    arg = nil
    arr = string.split(C1)
    arr.each_index do |i|
      if i&1 == 0
        arr[i].split(C2).each do |arg|
          command << arg
        end
      else
        command << arr[i]
      end
    end
    return command
  end
  
  def load_data(filename)
    return nil unless File.exist?(filename)
    File.open(filename, "r") do |f| return Marshal.load(f) end
  end
  
  def save_data(var, filename)
    File.open(filename, "w") do |f| Marshal.dump(var, f) end
  end
  
  def get_string(id)
    return @strings[id-1]
  end
  
  def load_string(filename)
    File.open("strings/#{LANG}/#{filename}.txt", "r") do |f|
      @strings = f.read(f.size).force_encoding("UTF-8").split(/[\r\n]+/)
    end
  end
end