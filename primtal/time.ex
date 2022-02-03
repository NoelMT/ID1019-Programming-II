defmodule Bench do
    def test do

    {elem(:timer.tc(Pett, :prim, [1000]),0), elem(:timer.tc(Ptva, :prim, [1000]),0) , elem(:timer.tc(Ptre, :prim, [1000]),0)}
     
    end

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
    prim(Enum.to_list(2..n),[])
    end

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


