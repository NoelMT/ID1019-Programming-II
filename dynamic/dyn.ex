defmodule Req do

def split(seq) do split(seq, 0, [], []) end
def split([], l, left, right) do
[{left,right,l}]
end

def split([s|rest], l, left, right) do
split(rest, l+s, [s|left], right) ++ split(rest, l+s, left,[s|right])
end

def cost([]) do "dont" end
def cost([_]) do 0 end
def cost(seq) do 
cost(seq, 0, [], []) end
def cost([], l, left, right) do
l + cost(left) + cost(right)
end
def cost([s], l, [], right) do
l + cost(right) + s
end
def cost([s], l, left, []) do
l +  + cost(left) + s 
end
def cost([s|rest], l, left, right) do
lp = cost(rest, l+s, [s|left], right) #least cost of left 
rp = cost(rest, l+s, left, [s|right]) #least cost of right
if lp > rp do
    rp
    else
    lp
    end
end


#--------------------------path
def cost2([]) do {0,nil} end
def cost2([s]) do {0,s} end
def cost2(seq) do cost2(seq, 0, [], []) end
def cost2([], l, left, right) do
{sl,pathL}=cost2(left)
{rl,pathR}=cost2(right)
{l + sl + rl,{pathL,pathR}}
end
def cost2([s], l, [], right) do
{rl,pathR}=cost2(right)
{l + rl+s,{s,pathR}}
end
def cost2([s], l, left, []) do
{sl,pathL} = cost2(left)
{l + sl + s, {s,pathL}}
end
def cost2([s|rest], l, left, right) do
{lp,pathL} = cost2(rest, l+s, [s|left], right) #least cost of left
{rp,pathR} = cost2(rest, l+s, left, [s|right]) #least cost of right
if lp > rp do
    {rp,pathR}
    else
    {lp,pathL}
    end
end

def bench(n) do
for i <- 1..n do
{t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
IO.puts(" n = #{i}\t t = #{t} us")
end
end

end

defmodule Dyn do 
def cost([]) do {0, :na} end
def cost(seq) do
{cost, tree, _} = cost(seq, Memo.new())
{cost, tree}
end

def cost([s], mem) do {0, s, mem} end
def cost(seq, mem) do
{c, t, mem} = cost(seq, 0, [], [], mem)
{c, t, Memo.add(mem, seq, {c, t})}
end

#cost5
  def cost([], l, left, right, mem)  do
    {cl, sl, mem} = check(left, mem)
    {cr, sr, mem} = check(right, mem) #skriver man inte över mem då??
    {cl+cr+l, {sl,sr}, mem}
    end

 def cost([s], l, left, [], mem)  do
    {cl, sl, mem} = check(left, mem)
    {cl + l + s, {sl, s}, mem}
    end

  def cost([s], l, [], right, mem) do
   {cr, sr, mem} = check(right, mem)
   {cr + l + s, {s, sr}, mem}
    end


def cost([s|rest], l ,left,right,mem ) do #klar
{cl,pathL,mem}  = cost(rest, l+s, [s|left], right, mem)
{cr,pathR,mem} = cost(rest, l+s, left, [s|right], mem)
if cl > cr do
    {cr,pathR,mem}
    else
    {cl,pathL,mem}
    end
end

def check(seq, mem) do #klar
    case Memo.lookup(mem, seq) do
        nil ->
        {cos, path, mem} = cost(seq, mem)
        {cos,path, Memo.add(mem,seq,{cos,path})}
        {c, t} ->
        {c, t, mem}
    end
end
def bench(n) do
for i <- 1..n do
{t,_} = :timer.tc(fn() -> Dyn.cost(Enum.to_list(1..i)) end)
IO.puts(" n = #{i}\t t = #{t} us")
    end
    end
end

defmodule Memo do
def new() do %{} end
def add(mem, key, val) do Map.put(mem, key, val) end
def lookup(mem, key) do Map.get(mem, key) end
end

