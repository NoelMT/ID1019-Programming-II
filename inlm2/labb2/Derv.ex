defmodule De do
    
@type literal() :: {:num, number()}
| {:var, atom()}

@type expr() :: {:add, expr(), expr()}
| {:mul, expr(), expr()}
| literal()

def deriv({:num, _}, _) do {:num,0} end
end