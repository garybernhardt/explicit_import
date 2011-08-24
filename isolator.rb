CantTouchThis = Class.new do
  def to_s
    '<CantTouchThis>'
  end
end.new

class Stripper
  def self.strip(klass)
    klass.class_eval do
      Stripper::constants_to_remove.each do |c|
        self.const_set c.to_sym, CantTouchThis
      end
    end
  end

  def self.constants_to_remove
    exceptions = %w{Object Class Module}
    Object.constants - exceptions
  end
end

class Joe
  Stripper::strip(self)

  def self.get_io
    IO
  end

  def get_file
    File
  end
end

# These print the constants; they still exist
puts IO.inspect
puts File.inspect

# These print <CantTouchThis>; the constants are gone inside Joe
puts Joe.get_io.inspect
puts Joe.new.get_file.inspect

