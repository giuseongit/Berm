require "../src/berm.cr"

include Berm

class SymbolFlag < Flag
  FlagValues = %i(Read Write)
end

class StringFlag < Flag
  FlagValues = %w(Read Write)
end

class LiteralStringArrayFlag < Flag
  FlagValues = {"Read", "Write"}
end

@[FlagsConstant("CUSTOM")]
class CustomVarFlag < Flag
  CUSTOM = %w(Read Write)
end
