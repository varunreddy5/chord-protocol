defmodule Bonus do
    def updatePreSuc(randNode) do
        adjli=Package1.curAdjli(randNode)
        succ = Enum.at(adjli,1)
        pred = Enum.at(adjli,0)
        sucAdjli=Package1.curAdjli(succ)
        preAdjli=Package1.curAdjli(pred)
        sucAdjli = [pred, Enum.at(sucAdjli,1)]
        preAdjli = [Enum.at(preAdjli,0), succ]
        Package1.adjNodeLi(succ, sucAdjli)
        Package1.adjNodeLi(pred, preAdjli)
        # IO.inspect sucAdjli
        # IO.inspect preAdjli
    end

    def updateFingmap(randNode, li, keyReqli) do
        li=li--[randNode]
        adjli=Package1.curAdjli(randNode)
        succ = Enum.at(adjli,1)
        Enum.each(li, fn(proc)->
            fingMap = Package1.curFinmap(proc)
            valueli = Map.values(fingMap)
            keyli = Map.keys(fingMap)
            #IO.inspect valueli
            count = Enum.count(valueli, fn(x) -> x==randNode end)
            #IO.puts count
            indexli = Enum.with_index(valueli) |> Enum.filter_map(fn {x, _} -> x == randNode end, fn {_, i} -> i end)
            #IO.inspect indexli
            fingMap = if (count != 0) do
                        mapUpdate(fingMap, indexli, succ, keyli, Enum.count(indexli)-1)
                      else
                        fingMap
                      end
            #IO.inspect fingMap
            Package1.processFinmap(proc, fingMap)
        end)
        Package1.killfun(randNode)
        :timer.sleep(1)
        #IO.inspect Process.alive?(randNode)
        Compute.mainFun(li, keyReqli)
        System.halt(1)
    end

    def mapUpdate(fingMap, indexli, succ, keyli, n) do
        if(n>=0) do
            pos = Enum.at(indexli, n)
            key = Enum.at(keyli, pos)
            mapUpdate(Map.replace!(fingMap, key, succ), indexli, succ, keyli, n-1)
        else
            fingMap
        end
    end
end
