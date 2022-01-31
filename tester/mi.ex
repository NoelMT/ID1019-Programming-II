
    #add
    #sub
    #addi
    #lw
    #sw

     #klar
defmodule Out do 
    def new() do [0] end
    def put(out,s) do [s|out]  end 
    def close(out) do Enum.to_list(out) end
end

#klar
defmodule Register do
    def new() do
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} end 
    def read(reg,index) do
    elem(reg,index) end
    def write(reg,index,val) do put_elem(reg,index,val) end
 end
defmodule Program do
    def load([],_,{code,data}) do {{:code, List.to_tuple( removelabel(code,[],data))},data }  end #code returnes as tupple and data as a list
    def load([h|t],counter,{code,data}) do 
        case h do
            {:label,name}->load(t,counter+1,{code,[{name,counter}|data]})

             n->load(t,counter+1,{[n|code],data})
        
        end
    end
    def removelabel([],removed,_) do removed end #kallas som removelabel(code,[],data,0)
    def removelabel([h|t],removed,data) do 
        case h do 
        {:bne,rd,rs,label}->  removelabel(t,[{:bne,rd,rs,lookup(data,label)}|removed],data)
        
        n-> removelabel(t,[n|removed],data)
        end 
    end

    def lookup([],_) do "no jump :(" end
    def lookup([{label,pc}|_],label) do pc end
    def lookup([_|t],label) do lookup(t,label) end


    def read_instruction({:code,inst},pc) do elem(inst,pc) end
 end


 defmodule Mem do 
    def new() do [] end
    def input do  end
    def save(mem,index,val) do put_elem(mem,index,val) end

 end

#[{:addi, 1, 0, 5}, # $1 <- 5
#{:lw, 2, 0, :arg}, # $2 <- data[:arg]
#{:add, 4, 2, 1}, # $4 <- $2 + $1
#{:addi, 5, 0, 1}, # $5 <- 1
#{:label, :loop},
#{:sub, 4, 4, 5}, # $4 <- $4 - $5
#{:out, 4}, # out $4
#{:bne, 4, 0, :loop}, # branch if not equal
#:halt]


defmodule Emulator do

    def run() do
        #{code, data} = Program.load(prgm)
        prgm = [{:addi,1,0,50},{:addi,2,1,25},{:sub,3,2,1},{:addi,5,0,10},{:label, :loop},{:addi,6,6,1},{:bne,5,6,:loop},{:halt}]
        {code,data} = Program.load(prgm,0,{[],[]})
        #data = Program.getdata(prgm,0,[])
        
        out = Out.new()
        IO.puts("\n Instructions: ")
        IO.inspect(code) #1
        IO.puts("\n Labels and pc: ")
        IO.inspect(data) #2
        reg = Register.new()
        run(0, code, reg, data, out)
    end

    def run(pc, code, reg, mem, out) do
        next = Program.read_instruction(code, pc)
        #IO.inspect({pc,out})
        case next do
            {:halt}->{"Output:  " ,Out.close(out)}

            {:label,_sum}-> run(pc+1, code, reg, mem, out)

            {:out, rs}->
                pc = pc + 1
                s = Register.read(reg, rs)
                out = Out.put(out, s)
                run(pc, code, reg, mem, out)

            {:add, rd,rs,rt}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) + Register.read(reg,rt))
                out = Out.put(out,Register.read(reg,rd) ) 
                run(pc, code, reg, mem, out)

            {:addi, rd,rs,imm}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) + imm)
                out = Out.put(out,Register.read(reg,rd) )  
                run(pc, code, reg, mem, out)

            {:sub, rd,rs,rt}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) - Register.read(reg,rt))
                out = Out.put(out,Register.read(reg,rd))  
                run(pc, code, reg, mem, out)

            {:bne,rd,rs,val}->  #ett mer dynamiskt system för att hitta pc måste fixas
            pc = pc + 1
            #val = Mem.lookup(mem,label)

            #IO.inspect(Register.read(reg,rd))
            #IO.inspect(Register.read(reg,rs))
            if  Register.read(reg,rd) != Register.read(reg,rs) do  run(val, code, reg, mem, out)
            else
            run(pc, code, reg, mem, out)end
    end

 #implement tree
  end
end


