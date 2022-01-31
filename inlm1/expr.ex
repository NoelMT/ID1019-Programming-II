defmodule Power do
#function
def product_case(m, n) do
case m do
0 -> 0
m -> n + product_case(m-1,n)
        end
    end
#prolog style
def product_clauses(0, _) do 0 end
def product_clauses(m, n) do product_clauses( m-1, n) + n end

def expAr(x, n) do
cond do
    n == 1 -> x
    rem(n,2) == 0 ->  product_case(exp(x,div(n,2)),x)
    rem(n,2) == 1 -> product_case(exp(x,(n-1)),x)
    end
    end



end


