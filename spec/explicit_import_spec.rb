require 'lib/explicit_import'

class Joe
  import 'Enumerable', 'File::Constants', 'File::Enumerator'

  def self.get_io
    IO
  end

  def get_io_on_instance
    IO
  end

  def self.get_enumerable
    Enumerable
  end

  def self.get_file_constants
    File::Constants
  end

  def self.get_file_enumerator
    File::Enumerator
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
    Joe.get_enumerable.should be_a Module
  end

  it "can import nested constants" do
    Joe.get_file_constants.should be_a Module
    Joe.get_file_enumerator.should be_a Module
  end
end

