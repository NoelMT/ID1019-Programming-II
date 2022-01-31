defmodule Te do 
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(x) do fib(x-1) + fib(x-2) end
end