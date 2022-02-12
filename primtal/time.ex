defmodule Bench do
    def test() do Dummy.dumdum(1000000) end
    def test(n) do

    { (elem(:timer.tc(Pett, :prim, [n]),0)) / :math.pow(10,6), elem(:timer.tc(Ptva, :prim, [n]),0)/ :math.pow(10,6) , elem(:timer.tc(Ptre, :prim, [n]),0)/ :math.pow(10,6)}
    end
  end
#Enum.map([500,1000,3000,6000,10000],&Bench.test/1)
defmodule Dummy do
def dumdum(0) do Enum.map([10000,15000,20000,25000,30000,35000,40000,45000,50000],&Bench.test/1) end
def dumdum(n) do dumdum(n-1) end
end

defmodule Pett do
    
    def prim ([]) do [] end
    def prim([h|t]) do 
    [h| prim( remove(t,h))]
    end
    def prim(n) do  
    prim(Enum.to_list(2..n) )
    end
    
    
    def remove([],_) do [] end
    #metod som tar bort element e ur listan
    def remove([h|t],e) do
        case rem(h,e) do
        0->remove(t,e)
        _->[h|remove(t,e)]
        end
    end
end

defmodule Ptva do 


    def prim([],plist) do plist end
    def prim([h|t],plist) do 
    prim(t,check(h,plist))
    end
    def prim(n) do 
    prim(Enum.to_list(2..n),[]) end

#metod som tar emot element och lista, kollar om elementet är delbar med 
#med något tal i listat, listan iteraras till slut och sätter in element på slutet
#om de delbart returnera samma list
def check(e,[]) do [e] end
def check(e,[h|t]) do
    case rem(e,h) do
    0->[h|t]
    _->[h|check(e,t)]
    end
end
       
end


defmodule Ptre do 


    def prim([],plist) do reverse(plist) end
    def prim([h|t],plist) do
        if check(h,plist) do
        prim(t,[h|plist])
        else
        prim(t,plist)
        end
    end
    def prim(n) do 
    prim(Enum.to_list(2..n),[])
    end

#metod som tar emot element och lista, kollar om elementet är delbar med 
#med något tal i listat, listan iteraras till slut och returnerar true om inget tal i listan delar elementet och false om något tal delar elementet 
def check(_,[]) do true end
def check(e,[h|t]) do
    case rem(e,h) do
    0->false
    _->check(e,t)
    end
end
#rekursiv metod som vänder listan
def reverse(list) do reverse(list,[]) end
def reverse([],list) do list end
def reverse([h|t],list) do reverse(t,[h|list]) end

end


#trean e långsamast eftersom listan måste vändas om en extra gång och den är i decsending order


