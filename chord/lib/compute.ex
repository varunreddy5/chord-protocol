defmodule Compute do
    def nearpow(num,a) do
        a=a*2
        if(num>a) do
          nearpow(num,a)
        else
          a
        end
      end

    def adjli(li) do
        len=Enum.count li
            Enum.each(li, fn(x) ->
                pos = Enum.find_index(li, fn(y)-> y == x end)
                #nibList=[]
                x1 = if(pos>=0) do
                        if(pos==0) do
                          Enum.at(li, len-1)
                        else
                          Enum.at(li, pos-1)
                        end
                     end

                x2 = if(pos<=len-1) do
                        if(pos==len-1) do
                          Enum.at(li, 0)
                        else
                          Enum.at(li, pos+1)
                        end
                     end
                nibList = [x1, x2]
                #IO.inspect nibList
                Package1.adjNodeLi(x, nibList)
            end)
    end

    def hashfun(li,reqli,num) do
        m=round(:math.log2(num))
        min=Enum.at(reqli,0)
        max=Enum.at(reqli,Enum.count(reqli)-1)
        #finmap=%{}
        Enum.each(li, fn(x) ->
            id=Package1.curNodeId(x)
            # IO.inspect id
            finelemli=Enum.map(0..m-1, fn(y) ->
                      sum = id+round(:math.pow(2,y))
                      res = if(rem(sum,num)!=0) do
                              rem(sum,num)
                            else
                              num
                            end
                      res
                      end)
            #IO.inspect finelemli
            finli=Enum.map(finelemli, fn(z) ->
                  fin = if(z>max||z<min) do
                          0
                        else
                          if(Enum.member?(reqli,z)==true) do
                            Enum.find_index(reqli, fn(el)-> el==z end)
                          else
                            succli(reqli,1,z)
                          end
                        end
                    fin
                  end)
            #IO.inspect finli
            finmap=mapfun(%{}, finelemli, li, finli, m-1, Enum.count(finli)-1)
            # IO.inspect finmap
            Package1.processFinmap(x, finmap)
        end)
    end

    def succli(reqli,pos,res) do
      if(res<Enum.at(reqli,pos)) do
        #Enum.at(reqli,pos)
        pos
      else
        succli(reqli,pos+1,res)
      end
    end

    def mapfun(resmap, finelemli, li, finli, m, n) do
      if(n>=0) do
        pos= Enum.at(finli,n)
        #IO.inspect pos
        mapfun(Map.put(resmap, Enum.at(finelemli, m), Enum.at(li, pos)), finelemli, li, finli, m-1, n-1)
      else
        resmap
      end
    end

    def mainFun(nodeli, keyReqli) do
      nodeCount = Enum.count(nodeli)
      reqCount = Enum.count(keyReqli)
      finalHopli = Enum.map(nodeli, fn(proc) ->
        # nodeHops = Package1.keyFun(proc, keyReqli)
        # IO.inspect nodeHops
        # Enum.sum(nodeHops)
        nodeHopSum = Package1.keyFun(proc, keyReqli)
        #nodeHopSum = Package1.curHopcount(proc)
        # IO.puts "in main fun, hop sum: #{nodeHopSum}"
        nodeHopSum
      end)
      avg = Enum.sum(finalHopli)/(nodeCount*reqCount)
      IO.puts "Final average number of hops: #{avg}"
      System.halt(1)
      # nodeHops = Package1.keyFun(nodeele, keyReqli)
      # IO.inspect nodeHops
      # Enum.each(keyReqli, fn(key) ->
      #   hop=findKey(nodele, key, 0)
      #   IO.puts "hops are: #{hop}"
      # end)
    end

    def findKey(id, fingtab, key, cur) do
      #id=Package1.curNodeId(nodeele)
      #fingtab=Package1.curFinmap(nodeele)
      finglis=Map.keys(fingtab)
      firstFing=Enum.at(finglis,0)
      lastFing=Enum.at(finglis, Enum.count(finglis)-1)
      count=if key==id do
              cur
            else
              if (Enum.member?(finglis,key)==true) do
                cur+1
              else
                if (key>lastFing || key<id && key<firstFing) do
                  nextpid=Map.get(fingtab, lastFing)
                  nid=Package1.curNodeId(nextpid)
                  nfingtab=Package1.curFinmap(nextpid)
                  findKey(nid, nfingtab, key, cur+1)
                else
                  if(key>firstFing) do
                    pos=succli(finglis, 1, key)
                    pred=Enum.at(finglis, pos-1)
                    succ=Enum.at(finglis, pos)
                    if(Map.get(fingtab, pred)==Map.get(fingtab, succ)) do
                      cur+1
                    else
                      nextpid=Map.get(fingtab, pred)
                      nid=Package1.curNodeId(nextpid)
                      nfingtab=Package1.curFinmap(nextpid)
                      findKey(nid, nfingtab, key, cur+1)
                    end
                  end
                end
              end
            end
      count
    end
end
