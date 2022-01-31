defmodule Four do 

# returnes the nth number in the list
def nth(0,[h|_]) do h end
def nth(n,[_|t]) do nth(n-1,t) end

#len calc the length of lists
def len([]) do 0 end
def len([_|t]) do 1 + len(t) end

#sum calc the sum of lists
def sum([]) do 0 end
def sum([h|t]) do h + sum(t) end

#duplicates all elements



end