require 'lib/explicit_import'

class Joe
  import :File

  def self.get_io
    IO
  end

  def get_io_on_instance
    IO
  end

  def self.get_file
    File
  end
end

describe ExplicitImport do
  it "leaves global constants alone" do
    IO.should be_a Module
  end

  it "replaces constants in class methods" do
    Joe.get_io.should_not be_a Module
  end

  it "replaces constants in instance methods" do
    Joe.new.get_io_on_instance.should_not be_a Module
  end

  it "leaves imported constants alone" do
    Joe.get_file.should be_a Module
  end
end

