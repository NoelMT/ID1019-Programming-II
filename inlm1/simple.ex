defmodule Basic do
#double of n
def double(n) do n*2 end

#fahrenheit to celsius
def f2c(f) do (f-32)/1.8 end

#area of rektangle
def area(b,h) do b*h end
#area of square
def areaSq(l) do area(l,l) end
#area of circle
def areaCircle(r) do (r*r) *  3.142 end 

end