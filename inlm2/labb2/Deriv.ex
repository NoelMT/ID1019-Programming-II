defmodule Der do

@type literal() :: {:num, number()}
| {:var, atom()}

@type expr() :: literal()
|{:add, expr(), expr()}
| {:mul, expr(), expr()}
| {:exp, expr(),literal()}
| {:log, expr()}
| {:div, expr(),expr()}
| {:neg, expr()}
| {:sqrt, expr()}
| {:sin, expr()}
| {:cos, expr()}


def test() do
  xpr = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
  _expont = {:exp,{:var, :x} ,{:num, 5}}
  _lg = {:log,{:add, {:var, :x},{:var,:y}}}
  _oneoverx =  {:div,{:num, 1} ,{:var, :x}}
  _skuere =  {:sqrt,{:var, :x}}
  _trig =  {:sin,{:var, :x}}
  z = deriv(xpr,:x)
  #pp(z)
  #IO.inspect(z)
  IO.write("expression: #{pp(xpr)}\n")
  IO.write("derivative: #{pp(z)}\n")
  IO.write("simplified: #{pp(simp(z))}\n")
  #

   end

   def run() do

    dez = IO.gets "select test: "
    trim = String.trim(dez)
    case trim do
      "1" -> z = deriv({:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, :x)
    IO.write("expression: {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}\n")
    IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      "2" -> z = deriv({:exp,{:var, :x} ,{:num, 5}}, :x)
      IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      "3" -> z = deriv({:log,{:add, {:var, :x},{:var,:y}}}, :x)
      IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      "4" -> z = deriv({:div,{:num, 1} ,{:var, :x}}, :x)
      IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      "5" -> z = deriv({:sqrt,{:var, :x}}, :x)
      IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      "6" -> z = deriv({:sin,{:mul,{:num,2},{:var, :x}}}, :x)
      IO.write("derivative: #{pp(z)}\n")
    IO.write("simplified: #{pp(simp(z))}\n")
      end
    #IO.write("expression: #{pp(z)}\n")



     end

#basic deriv rules-------------------------------------------------
def deriv({:num, _}, _) do {:num,0} end
def deriv({:var, v}, v) do {:num, 1} end
def deriv({:var, _}, _) do {:num,0} end
def deriv({:add, e1, e2}, v) do {:add, deriv(e1,v), deriv(e2,v)} end
def deriv({:mul, e1, e2}, v) do {:add, {:mul, deriv(e1,v),e2}, {:mul, deriv(e2,v),e1}} end
#------------------------------------------------------------------
#deriv of x^n where n is an integer
def deriv({:exp,x,{:num, n}},v) do {:mul,{:mul, {:num,n}, {:exp,x,{:num,n-1}}},deriv(x,v) } end
#deriv of ln
def deriv({:log,x},v) do {:div,deriv(x,v),x} end
#deriv of 1/x
def deriv({:div,{:num,e1},x},v ) do {:div , {:neg,{:mul,{:num,e1},deriv(x,v)}} , {:exp, x,{:num,2}} } end
#deriv of sqrt(x)
def deriv({:sqrt,e1},v) do {:div, {:mul, {:num,1}, deriv(e1,v) },{:mul,{:num,2},{:sqrt,e1} } } end
#deriv of sin
def deriv({:sin,e1},v) do {:mul, deriv(e1,v),{:cos,e1}} end

#-------------------------------------------------------------------

#Better prints------------------------------------------------------
def pp({:num,n}) do "#{n}" end
def pp({:var,v}) do "#{v}" end
def pp({:add,e1,e2}) do "#{pp(e1)} + #{pp(e2)}" end
def pp({:mul,e1,e2}) do  "#{pp(e1)}*#{pp(e2)}"end
def pp({:exp,e1,e2}) do "(#{pp(e1)}^#{pp(e2)})" end
def pp({:log,e1}) do "ln(#{pp(e1)})" end
def pp({:div,e1,e2}) do "(#{pp(e1)} / #{pp(e2)})"end
def pp({:neg,e1}) do "-(#{pp(e1)})" end
def pp({:sqrt,e1}) do "sqrt(#{pp(e1)})" end
def pp({:sin,e1}) do "sin(#{pp(e1)})" end
def pp({:cos,e1}) do "cos(#{pp(e1)})" end
#-------------------------------------------------------------------

#simplyfi-----------------------------------------------------------


def simp({:add, e1,e2 }) do
simpadd(simp(e1),simp(e2)) end
def simp( {:mul, e1,e2 }) do
simpmul(simp(e1),simp(e2)) end
def simp({:div,e1,e2 }) do
simpdiv(simp(e1),simp(e2)) end
#handles expresions with one parameter
def simp({literal,e1}) do {literal,simp(e1)} end


def simp(e) do e end

def simpadd({:num,0},e2) do e2 end
def simpadd(e1,{:num,0}) do e1 end
def simpadd({:num,n1},{:num,n2}) do {:num,n1+n2} end
def simpadd(e1,e2) do {:add,e1,e2} end

def simpmul({:num,0},_) do {:num,0} end
def simpmul(_,{:num,0}) do {:num,0} end
def simpmul({:num,1},e2) do e2 end
def simpmul(e1,{:num,1}) do e1 end
def simpmul({:num,n1},{:num,n2}) do {:num,n1*n2} end
def simpmul(e1,e2) do {:mul,e1,e2} end

def simpexp(_,{:num,0}) do {:num,1} end
def simpexp(e1,{:num,1}) do e1 end
def simpexp(e1,e2) do {:exp, e1,e2} end

def simpdiv({:num, 0},_) do {:num,0} end
def simpdiv(e1,{:num, 1}) do e1 end
def simpdiv(e1,e2) do {:div, e1,e2} end

#-------------------------------------------------------------------
end
