require "spec"
require "../src/berm"

class ReadWriteFlag < Berm::Flag
  FlagValues = %i(Read Write)
end

@[Berm::FlagsConstant("MyConst")]
class CustomVarFlags < Berm::Flag
  MyConst = %i(A B)
end

class StringArrayFlags < Berm::Flag
  FlagValues = %w(A B)
end
