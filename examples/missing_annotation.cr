require "../src/berm.cr"

include Berm

class MyFlag < Flag
  FlagValues = %i(Read Write)

  ReadWrite = MyFlag::Write | MyFlag::Read
end
