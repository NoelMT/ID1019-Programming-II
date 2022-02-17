defmodule Two do 

    def ans() do (down() - up())*forward() end 
    def forward do
   {_,text} = File.read("inp.txt")
    text|>
    String.replace("\n","") |>
    String.split("\r", trim: true) |>
    Enum.map(fn x -> if String.at(x,0) == "f" do String.to_integer(String.at(x,8)) end end)
    |> Enum.map(fn x -> if x == nil  do 0 else x end end)
    |> Enum.reduce(0,fn x,ack -> if x != nil do ack+x end  end)

    #String.replace("\r","") 
    end
    def down do
   {_,text} = File.read("inp.txt")
    text|>
    String.replace("\n","") 
    |> String.split("\r", trim: true) 
    |>Enum.map(fn x -> if String.at(x,0) == "d" do String.to_integer(String.at(x,5)) end end)
    |> Enum.map(fn x -> if x == nil  do 0 else x end end)
    |> Enum.reduce(0,fn x,ack -> if x != nil do ack+x end  end)

    #String.replace("\r","") 
    end
    def up do
   {_,text} = File.read("inp.txt")
    text|>
    String.replace("\n","") 
    |> String.split("\r", trim: true) 
    |>Enum.map(fn x -> if String.at(x,0) == "u" do String.to_integer(String.at(x,3)) end end)
    |> Enum.map(fn x -> if x == nil  do 0 else x end end)
    |> Enum.reduce(0,fn x,ack -> if x != nil do ack+x end  end)

    #String.replace("\r","") 
    end
   # def count([],ack) do ack end
    #def count([h|t],ack) do end
     #Enum.map(fn x -> if String.at(x,0) == "f" do String.at(x,8) end end)
end