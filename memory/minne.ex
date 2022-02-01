
    #add
    #sub
    #addi
    #lw
    #sw

     #klar
defmodule Out do 
    def new() do [0] end
    def put(out,s) do [s|out] end 
    def close(out) do Enum.to_list(out) end
end

#klar
defmodule Register do #register 0 är alltid 0
    def new() do
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} end 
    def read(reg,index) do
    elem(reg,index) end
    def write(reg,index,val) do put_elem(reg,index,val) end
 end
defmodule Program do
    def load([],_,{code,data}) do {{:code, List.to_tuple( removelabel(code,[],data))},data }  end #code returnes as tupple and data as a list: 
    def load([h|t],counter,{code,data}) do  #first call load(prgm,0,{[],[]})
        case h do
            {:label,name}->load(t,counter+1,{code,[{name,counter}|data]})
             n->load(t,counter+1,{[n|code],data})
        end
    end
    def removelabel([],removed,_) do removed end #kallas som removelabel(code,[],data)
    def removelabel([h|t],removed,data) do 
        case h do                                               #:loop --> 6
        {:bne,rd,rs,label}->  removelabel(t, [{:bne,rd,rs,lookup(data,label)}|removed] ,data)
        
        n-> removelabel(t,[n|removed],data)
        end 
    end

    def lookup([],_) do "no jump :(" end
    def lookup([{label,pc}|_],label) do pc end
    def lookup([_|t],label) do lookup(t,label) end


    def read_instruction({:code,inst},pc) do elem(inst,pc) end #if pc increment by 4 devide pc by 4
 end


 defmodule Mem do 
    def new() do [] end

    def read([h|t],addr) do   #[{30,2000},{560,7}{30,2000}{30,2000}{30,2000}]
        case h do 
            []->0
            {^addr,val}->val
            _->read(t,addr)
        end
    end

    def write(mem,addr,val) do 
        if member(mem,addr) do
        find(mem,addr,[],val) 
        else
        [{addr,val}|mem]
        end
    end

    def member([],_) do false end
    def member([h|_],h) do true end
    def member([_|t],addr) do member(t,addr) end

    def find([],_,list,_) do list end
    def find([{addr,_}|t],addr,list,val) do find(t,addr,[{addr,val}|list],val) end
    def find([h|t],addr,list,val) do find(t,addr,[h|list],val) end
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

#[{:addi, 1, 0, 5}, # $1 <- 5
#{:lw, 2, 0, :arg}, # $2 <- data[:arg]
#{:add, 4, 2, 1}, # $4 <- $2 + $1
#{:addi, 5, 0, 1}, # $5 <- 1
#{:sub, 4, 4, 5}, # $4 <- $4 - $5
#{:out, 4}, # out $4
#{:bne, 4, 0, :loop}, # branch if not equal
#:halt]

#[{:addi, 1, 0, 5}, # $1 <- 5
#{:lw, 2, 0, 12}, # $2 <- data[:arg]
#{:add, 4, 2, 1}, # $4 <- $2 + $1
#{:addi, 5, 0, 1}, # $5 <- 1
#{:sub, 4, 4, 5}, # $4 <- $4 - $5
#{:out, 4}, # out $4
#{:bne, 4, 0, 4}, # branch if not equal
#:halt]


defmodule Emulator do

    def run() do
        #{code, data} = Program.load(prgm)            value är 50 i addr 5
        prgm = [{:addi,1,0,50},{:addi,2,1,25},{:sub,3,2,1},{:sw,1,5,0},{:lw,8,5,0},{:addi,5,0,10},{:label, :loop},{:addi,6,6,1},{:bne,5,6,:loop},{:halt}]
        {code,data} = Program.load(prgm,0,{[],[]})
        #data = Program.getdata(prgm,0,[])
        mem = Mem.new()
        out = Out.new()
        IO.puts("\n Instructions: ")
        IO.inspect(code) #1
        IO.puts("\n Labels and pc: ")
        IO.inspect(data) #2
        IO.puts("\n")
        reg = Register.new()
        run(0, code, reg, data, out,mem)
    end

    def run(pc, code, reg, data, out,mem) do
        next = Program.read_instruction(code, pc)
        #IO.inspect({pc,out})
        case next do
            {:halt}->{"Output:  " ,Out.close(out), reg, "                    mem: ",mem}

            {:label,_sum}-> run(pc+1, code, reg, data, out,mem)

            {:out, rs}->
                pc = pc + 1
                s = Register.read(reg, rs)
                out = Out.put(out, s)
                run(pc, code, reg, data, out,mem)

            {:add, rd,rs,rt}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) + Register.read(reg,rt))
                out = Out.put(out,Register.read(reg,rd)) 
                run(pc, code, reg, data, out,mem)

            {:addi, rd,rs,imm}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) + imm)
                out = Out.put(out,Register.read(reg,rd) )  
                run(pc, code, reg, data, out,mem)

            {:sub, rd,rs,rt}->
                pc = pc + 1
                reg = Register.write(reg,rd, Register.read(reg,rs) - Register.read(reg,rt))
                out = Out.put(out,Register.read(reg,rd))  
                run(pc, code, reg, data, out,mem)

            {:bne,rd,rs,imm}->  
                pc = pc + 1
            #val = Mem.lookup(mem,label)
            #IO.inspect(Register.read(reg,rd))
            #IO.inspect(Register.read(reg,rs))
            if Register.read(reg,rd) != Register.read(reg,rs) do  run(imm, code, reg, data, out,mem)
            else
                run(pc, code, reg, data, out,mem)
            end
            #rt är value och addr blir rs+imm
            {:sw,rt,imm,rs}->
                pc = pc + 1
                mem = Mem.write(mem,imm + Register.read(reg,rs),Register.read(reg,rt))
                run(pc, code, reg, data, out,mem)

            {:lw,rt,imm,rs}->
                pc = pc + 1
                reg = Register.write(reg,rt, Mem.read(mem,imm+Register.read(reg,rs)))
                run(pc, code, reg, data, out,mem)
        end
    end
end


