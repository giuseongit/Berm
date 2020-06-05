# Berm [![Build Status](https://travis-ci.com/giuseongit/Berm.svg?token=gg8shaAxBygK2RDYeLJx&branch=master)](https://travis-ci.com/giuseongit/Berm) [![GitHub release](https://img.shields.io/github/release/giuseongit/Berm.svg)](https://github.com/giuseongit/Berm/releases)

Berm is a simple library that helps to manage permissions.

The name come from **b**inary p**erm**missions because it can easily manage permissions using byte operations.

### Rationale

bit operations are quite simple (and thus fast), and it's sometimes useful to have permission system that can be used programmatically, think about showing or hiding certain ui features based on the context. So the goal of this tool is to have a good permission system with the least hoverhead as possbile while being easy to use.

## Usage

The class `Berm::Flag` represent the permission manager.

It needs to know which flags it will have so you can use the `Berm::FlagsConstant("Myvar")` annotation or declaring the `FlagValues` variable. Only string and symbol array are supported.
```crystal
require "berm"

class MyFlag < Berm::Flag
  FlagValues = %i(Read Write)

  # Foreach flag value (aka permission) a constant is generated
  # Flags can be combined using the or operator
  ReadWrite = Write | Read
end

# For every permission a method `permits_{permission}?` is generated
puts MyFlag::Read.permits_read? # -> true
puts MyFlag::Read.permits_read? # -> false

puts MyFlag::ReadWrite.permits_read? # -> true
puts MyFlag::ReadWrite.permits_write? # -> true

# Also a None constant is generated to match the state of no permissions at all
# The permits_something? tells wheter there's at least one permission enabled
# it can be called on every permission
puts MyFlag::None.permits_something? # -> false
```

This is the basic usage, you can find more usage examples in `examples`.


## Contributing

1. Fork it (<https://github.com/your-github-user/berm/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Giuseppe Pagano](https://github.com/your-github-user) - creator and maintainer
