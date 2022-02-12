defmodule Sprim do 

def z() do z(0) end
def z(n) do fn -> {n,  z(n+1)} end end

def filter(next,nr) do
    {h,next} = next.()
    if rem(h,nr) != 0 do
     {h,fn -> filter(next,nr)end} 
    else    
        filter(next,nr)
    end
end
#func generetate all primes larger than 
#prime and is a prime number
#returns {next,fun} 
#next generate primes larger than p
#fun is function that generate number filtered by prime
def sieve(func,prime) do 
{nextprime,filrfunc} = filter(func,prime)
{nextprime,fn() -> filter(filrfunc,nextprime) end}
end

def primes() do
fn() -> {2, fn() -> sieve(Sprim.z(2),2) end} end
end

def infinity() do infinity(0) end
def infinity(n) do [n| fn -> infinity(n+1) end] end

end