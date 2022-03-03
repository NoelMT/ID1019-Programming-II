defmodule Chopstick do
def start do
_stick = spawn_link(fn -> available() end)
end

def available() do
    receive do
    {:request, from,ref} -> 
    send(from, {:granted,ref})
    gone() 
    :quit -> :ok
    end
end

def gone() do
    receive do
    :return -> available()
    :quit -> :ok
    end
end


def request(leftS,rightS) do
refL = make_ref()
refR = make_ref()
send(leftS, {:request, self(),refL})
send(rightS,{:request, self(),refR})
    mail(refL,refR,self(),0)
end
def mail(_,_,from,2) do send(from, :ok) end 
def mail(refL,refR,from,index) do 
    receive do
    {:granted,^refL} -> 
    mail(refL,refR,from,index+1)
    {:granted,^refR} -> mail(refL,refR,from,index+1)
    {:granted,_} ->  mail(refL,refR,from,index)
    end
   
end

def sleep(0) do :ok end
def sleep(t) do
:timer.sleep(:rand.uniform(t))
end

def quit(c) do Process.exit(c, :kill) end

end

defmodule Philosopher do 
def start(hunger,left,right,name,ctrl) do
    spawn_link(fn -> dream(hunger, left, right, name, ctrl) end)
end

def dream(0,_,_,_,ctrl) do send(ctrl,:done) end
def dream(hunger,left,right,name,ctrl) do
Chopstick.sleep(500)
case Chopstick.request(left,right) do
    :ok ->
    eat(hunger,left,right,name,ctrl)
    end
end


def eat(hunger,left,right,name,ctrl) do
Chopstick.sleep(10)
send(right,:return) #return chop right
send(left,:return) #return chop left
dream(hunger-1,left,right,name,ctrl)
end

end

defmodule Dinner do 
def start()  do
g=:os.system_time(:milli_seconds)
IO.inspect(g)
spawn(fn -> init() end) 
end

def init() do
c1 = Chopstick.start()
c2 = Chopstick.start()
c3 = Chopstick.start()
c4 = Chopstick.start()
c5 = Chopstick.start()
ctrl = self()
Philosopher.start(15, c1, c2, "Arendt", ctrl)
Philosopher.start(15, c2, c3, "Hypatia", ctrl)
Philosopher.start(15, c3, c4, "Simone", ctrl)
Philosopher.start(15, c4, c5, "Elisabeth", ctrl)
Philosopher.start(15, c5, c1, "Ayn", ctrl)
wait(5, [c1, c2, c3, c4, c5])
#tiden slut
g=:os.system_time(:milli_seconds)
IO.inspect(g)
end

def wait(0, chopsticks) do
IO.puts(" all sticks done!")
Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
end
def wait(n, chopsticks) do
receive do
:done ->
wait(n - 1, chopsticks)
:abort ->
Process.exit(self(), :kill)
end
end


end