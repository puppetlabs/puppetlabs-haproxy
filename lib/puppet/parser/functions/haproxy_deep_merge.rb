module Puppet::Parser::Functions
  newfunction(:haproxy_deep_merge, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Recursively merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 }, 'six' => [ 'έξι', 'sechs', 'zes' ] }
        $hash2 = {'two' => 'dos', 'three' => { 'five' => 5 }, 'six' => [ 'sechs', 'seis' ] }
        $merged_hash = haproxy_deep_merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash = { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 }, 'six' => [ 'έξι', 'sechs', 'zes', 'seis' ] }

    When there is a duplicate key that is a hash, they are recursively merged.
    When there is a duplicate key that is an array, they are concatenated and duplicate items removed.
    When there is a duplicate key that is not a hash and not an array, the key in the rightmost hash will "win."

    Note: This function is copied from puppetlabs-stdlib, renamed
    haproxy_deep_merge() and extended to support merging array values.
    ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, ("haproxy_deep_merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    haproxy_deep_merge = Proc.new do |hash1,hash2|
      hash1.merge(hash2) do |key,old_value,new_value|
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          haproxy_deep_merge.call(old_value, new_value)
        elsif old_value.is_a?(Array) && new_value.is_a?(Array)
          (old_value + new_value).uniq
        else
          new_value
        end
      end
    end

    result = Hash.new
    args.each do |arg|
      next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
      # If the argument was not a hash, skip it.
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, "haproxy_deep_merge: unexpected argument type #{arg.class}, only expects hash arguments"
      end

      result = haproxy_deep_merge.call(result, arg)
    end
    return( result )
  end
end
