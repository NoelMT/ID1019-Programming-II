defmodule Chopstick do
def start do
_stick = spawn_link(fn -> available() end)
end

def available() do
    receive do
    {:request, from} -> 
    send(from, :granted)
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


def request(stick, timeout) do
send(stick, {:request, self()})
receive do
:granted ->
:ok
after timeout ->
send(stick, :return)
:no
end
end

def sleep(0) do :ok end
def sleep(t) do
:timer.sleep(:rand.uniform(t))
end

def quit(c) do Process.exit(c, :kill) end

end

defmodule Philosopher do 
def start(hunger,left,right,name,ctrl,seed) do
IO.puts("#{seed}: Started dsedeing")
    :rand.seed(:exro928ss, {seed, seed, seed})
    spawn_link(fn -> dream(hunger, left, right, name, ctrl) end)
end

def dream(0,_,_,_,ctrl) do send(ctrl,:done) end
def dream(hunger,left,right,name,ctrl) do 
IO.puts("#{name}: Started dreaming")
Chopstick.sleep(600)
IO.puts("#{name}: stopped dreaming")
case Chopstick.request(left,:rand.uniform(200)) do
      :no -> dream(hunger,left,right,name,ctrl)
      :ok -> IO.puts("#{name} have taken left stick")        
        case Chopstick.request(right,:rand.uniform(400)) do
        :no -> send(left,:return)
        IO.puts("#{name} left stick returned")
        dream(hunger,left,right,name,ctrl)
          :ok ->
            IO.puts("#{name} have both sticks")
            eat(hunger,left,right,name,ctrl)
        end
    end
end


def eat(hunger,left,right,name,ctrl) do
Chopstick.sleep(100)
send(right,:return) #return chop right
send(left,:return) #return chop left
IO.puts("#{name} finished eating #{hunger-1} times left")
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
seed = 38290
c1 = Chopstick.start()
c2 = Chopstick.start()
c3 = Chopstick.start()
c4 = Chopstick.start()
c5 = Chopstick.start()
ctrl = self()
Philosopher.start(15, c1, c2, "Arendt", ctrl,seed+2)
Philosopher.start(15, c2, c3, "Hypatia", ctrl,seed+9)
Philosopher.start(15, c3, c4, "Simone", ctrl,seed-4)
Philosopher.start(15, c4, c5, "Elisabeth", ctrl,seed-7)
Philosopher.start(15, c5, c1, "Ayn", ctrl,seed-2)
wait(5, [c1, c2, c3, c4, c5])
end

def wait(0, chopsticks) do
IO.puts(" all sticks done!")
Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
g=:os.system_time(:milli_seconds)
IO.inspect(g)
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