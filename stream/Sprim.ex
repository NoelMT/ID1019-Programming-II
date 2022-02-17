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
#IO.inspect({prime,nextprime})
{nextprime,fn() -> sieve(filrfunc,nextprime) end}
end

def primes() do
fn() -> {2, fn() -> sieve(Sprim.z(3),2) end} end
end

def infinity() do infinity(0) end
def infinity(n) do [n| fn -> infinity(n+1) end] end

end

defmodule Primes do
defstruct [:next]
def primes() do
%Primes{next: Sprim.primes}
end

def next( %Primes{next: prim}) do 
{p,f} = prim.()
{p,%Primes{next: f}}
end


defimpl Enumerable do
def count(_) do {:error, __MODULE__} end
def member?(_, _) do {:error, __MODULE__} end
def slice(_) do {:error, __MODULE__} end
def reduce(_, {:halt, acc}, _fun) do
{:halted, acc}
end
def reduce(primes, {:suspend, acc}, fun) do
{:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
end
def reduce(primes, {:cont, acc}, fun) do
{p, next} = Primes.next(primes)
reduce(next, fun.(p,acc), fun)
end
end
end
