require "../src/berm.cr"

@[Berm::FlagsConstant("Flags")]
class MyFlag < Berm::Flag
  Flags = %i(Read Write)

  ReadWrite = Write | Read
end
