require "../src/berm.cr"

include Berm

@[FlagsConstant("Flags")]
class MyFlag < Flag
  Flags = %i(Read Write)

  ReadWrite = Write | Read
end
