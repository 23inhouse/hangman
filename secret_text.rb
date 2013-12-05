def foo(a=:default, b)
  puts "a=#{a}, b=#{b}"
end

foo(:value)
foo(:x, :y)
