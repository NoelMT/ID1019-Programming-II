defmodule Env do
@type atm :: {:atm, atom}
  @type variable :: {:var, atom}
  @type ignore :: :ignore
  @type cons(t) :: {:cons, t, t}

  # An environment is a key-value of variableiable to structure.


    
    def new do [] end #returnes new enviroment
    def add(id,str,env) do [{id,str}|env] end #returnes the invoroment with the new tuple added
    
    def lookup(_,[]) do nil end
    def lookup(id, [{id,val}|_]) do {id,val} end #retunes the tupple if id or nil
    def lookup(id,[_|t]) do lookup(id,t) end

    def remove(_,[]) do [] end
    def remove(ids,[{ids,_}|t]) do remove(ids,t) end
    def remove(ids,[h|t]) do [h|remove(ids,t)] end #retrunes env where all tupples of ids is removed
end

defmodule Eager do
def eval_expr({:atm, id}, _) do {:ok,id} end
def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
    nil -> :error 
    {_, str} -> {:ok,str}
    end
end
def eval_expr({:cons, h, t}, env) do #eval cons
    case eval_expr(h, env) do
    :error -> :error
    {:ok,hed} -> 
        case eval_expr(t, env) do
        :error -> :error
        {:ok, tail} -> {:ok,{hed,tail}}
        
        end
    end
end
def eval_expr({:case, expr, cls}, env) do #eval case
    case eval_expr(expr, env) do
    :error -> :error
    
    {:ok,te} ->
    eval_cls(cls, te, env)
    end
end

def eval_match({:atm,id}, id, env ) do {:ok,env} end
def eval_match(:ignore, _ ,env) do
{:ok, env}
end

def eval_match({:var,id}, pat, env ) do 
    case Env.lookup(id,env) do
        nil-> {:ok,Env.add(id,pat,env)}
        {_,^pat}->{:ok,env}
        {_,_}->:fail
    end
end
#def eval_match({:cons,{:var,id},{:var,id}}, _, _ ) do :fail end

def eval_match({:cons, hp, tp}, {headM,tailM}, env) do
    case eval_match(hp, headM, env) do
    :fail -> :fail
    {:ok,env} ->
    eval_match(tp, tailM, env)
    end
end
def eval_match(_, _, _) do
:fail
end

 def extract_vars({:var, x}) do
    [x]
    end
  def extract_vars({:cons, head, tail}) do 
  case head do 
  {:var,x}->[x|extract_vars(tail)]
  _->extract_vars(tail)
  end
end
def extract_vars({_,_}) do [] end 

def eval_scope(pat, env) do
Env.remove(extract_vars(pat), env) #tar bort värden så man kan matcha om element
end
def eval_seq([exp], env) do
IO.inspect(exp)
eval_expr(exp, env)
end
def eval_seq([{:match, pat, expr} | tail], env) do #math expr and patter
    case eval_expr(expr, env) do # eval expr
    :error -> :error

    {:ok,ans} -> 
    env = eval_scope(pat, env)
        case eval_match(pat, ans, env) do  #if proper match it will be added to the enviroment
        :fail -> :error
        {:ok, env} ->
        eval_seq(tail, env)
        end
    end
end
def eval(seq) do eval_seq(seq,Env.new) end


def eval_cls([], _, _) do :error end
def eval_cls([{:clause, ptr, seq} | cls], te, env) do
envp = eval_scope(ptr,env)
    case eval_match(ptr,te,envp) do
    :fail -> eval_cls(cls, te, env)
    {:ok, env} -> eval_seq(seq,env)
    end
end




end

#seq = [{:match, {:var, :x}, {:atm,:a}},{:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},{:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},{:var, :z}]
#{:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
#{:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
#{:var, z}]


#[{:match, {:var, :x}, {:atm, :a}},{:case, {:var, :x},[{:clause, {:atm, :b}, [{:atm, :ops}]},{:clause, {:atm, :a}, [{:atm, :yes}] } ] } ]