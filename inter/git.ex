defmodule Te  do
   
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
end

  @type expresion :: {:atm, atom},{:var, atom}
  @type variable :: {:var, atom}
  @type ignore :: :ignore
  @type cons(t) :: {:cons, t, t}