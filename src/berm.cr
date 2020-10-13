require "yaml"
module Berm
  VERSION = "0.1.0"

  # This annotations it used to tell Berm in which variable flag values are stored
  annotation FlagsConstant
  end

  # Flag is the permission manager.
  #
  # It loads permission values from the variable pointed out by the `FlagsConstant` annotation,
  # otherwise from FlagValues and raises a compilation error if there's none of the above.
  # This variable has to be an array of symbols or strings, starting with the capital letter.
  #
  # It stores the values in The enum `PermValues` using powers of two as values, which make
  # easy to combine multiple permissions.
  #
  # For each permission value happens the following:
  #   - the value is added to PermValues
  #   - the representation of the value as a `Flag` object is saved as class constant using the same name
  #   - a method permits_{value}? is generated telling if that permission is enabled NOTE: value, here, is converted in snake case.
  #
  # A None constant with `PermValues::None` is generated to be the zero-value.
  # A permits_something? method is added to tell if there's at least one permission enabled
  class Flag
    macro init_values
      @[Flags]
      enum PermValues
        None = 0
        {% if @type.has_constant?("FLAGVALUES") %}
          {% for perm in @type.constant("FLAGVALUES") %}
          {{perm.id}}
          {% end %}
        {% end %}
      end
    end

    macro build_consts
      {% if @type.has_constant?("FLAGVALUES") %}
        {% for perm in @type.constant("FLAGVALUES") %}
          {{perm.id}} = {{@type}}.new(PermValues::{{perm.id}}.value.to_u32)
        {% end %}
      {% end %}
      None = {{@type}}.new(PermValues::None.value.to_u32)
    end

    macro build_permission_requests
      {% if @type.has_constant?("FLAGVALUES") %}
        {% for perm in @type.constant("FLAGVALUES") %}
          def permits_{{perm.id.underscore}}?
            return @value & PermValues::{{perm.id}}.value == PermValues::{{perm.id}}.value
          end
        {% end %}
      {% end %}
      def permits_something?
        return @value != 0
      end
    end

    # the macro inherited is called right after that the class declaration has been made
    # so the class has no constant yet.
    # Instead, we put our code inside the finished macro to make sure that the class is fully defined.
    macro inherited
      macro finished
        # use verbatim to avoid macro escaping
        {% verbatim do %}
          {% if @type.annotation(Berm::FlagsConstant) == nil %}
            {% raise "Class variable FlagValues not found" if !@type.has_constant?("FlagValues") %}
            FLAGVALUES = {{FlagValues}}
          {% else %}
            {% raise "Class variable " + @type.annotation(Berm::FlagsConstant)[0] + " not found" if !@type.constant(@type.annotation(Berm::FlagsConstant)[0]) %}
            FLAGVALUES = {{@type.constant(@type.annotation(Berm::FlagsConstant)[0])}}
          {% end %}

          init_values
          build_consts

          getter value

          def initialize(@value : UInt32)
          end

          def |(other : {{@type}})
            {{@type}}.new(value | other.value)
          end

          def &(other : {{@type}})
            {{@type}}.new(value & other.value)
          end

          def ==(other : {{@type}})
            @value == other.value
          end

          def !=(other : {{@type}})
            @value != other.value
          end

          def to_s(io : IO)
            enabled = [] of PermValues
            PermValues.each do |val|
              enabled << val if value & val.value == val.value
            end
            enabled << PermValues::None if enabled.size == 0
            io << "{{@type}}::#{enabled.join("|")}"
          end

          def to_yaml(yaml : YAML::Nodes::Builder)
            enabled = [] of PermValues
            PermValues.each do |val|
              enabled << val if value & val.value == val.value
            end
            enabled << PermValues::None if enabled.size == 0

            yaml.scalar enabled.join("|").downcase
          end

          def from_string(string : String) : UInt32
            flags = string.split("|")
            res = 0_u32

            flags.each do |flag|
              PermValues.each do |val|
                res += val.to_u32 if val.to_s.downcase == flag
              end
            end

            return res
          end

          def initialize(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
            value = 0_u32
            if node.is_a?(YAML::Nodes::Scalar)
              value = from_string(node.value)
            end
            @value = value
          end

          build_permission_requests
        {% end %}
      end
    end
  end
end
