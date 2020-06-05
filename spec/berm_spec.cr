require "./spec_helper"

describe Berm do
  it "Subclasses are Berm::Flag and have a None" do
    item = ReadWriteFlag::None
    item.should be_a(Berm::Flag)
    item.value.should eq(0)
    item.permits_something?.should be_false
  end

  it "if value is 0 something is permitted" do
    item = ReadWriteFlag::Read
    item.value.should_not eq(0)
    item.permits_something?.should be_true
  end

  it "can combine flags" do
    read = ReadWriteFlag::Read
    write = ReadWriteFlag::Write
    
    read.permits_read?.should be_true
    read.permits_write?.should be_false

    write.permits_read?.should be_false
    write.permits_write?.should be_true
    
    read_write = read | write

    read_write.permits_read?.should be_true
    read_write.permits_write?.should be_true
  end

  it "Can get the constant variable from an annotation" do
    CustomVarFlags::A.should_not be_nil
    CustomVarFlags::B.should_not be_nil
  end

  it "Can get the values from a string array" do
    StringArrayFlags::A.should_not be_nil
    StringArrayFlags::B.should_not be_nil
  end
end
