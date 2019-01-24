defmodule Chord do
  def main(args\\[]) do
    {i,""}=Integer.parse(Enum.at(args,0))
    {j,""}=Integer.parse(Enum.at(args,1))
    #j=Enum.at(args,1)
    #k=Enum.at(args,2)
    #pid=spawn(Dosproj, :pmap, [i, j])
    chord(i, j)
  end

  def chord(num, req) do
    input=num
    num=Compute.nearpow(num,2)
    maxli=Enum.map(1..num,&(&1))
    reqli=Enum.take_random(maxli,input)
    keyReqli=Enum.take_random(maxli, req)
    reqli=Enum.sort(reqli)
    keyReqli=Enum.sort(keyReqli)
    # IO.inspect reqli
    # IO.inspect keyReqli
    li=Enum.map(reqli, fn(x) ->
      {:ok, pid}= Package1.start_link
      Package1.processIndex(pid, x)
      pid
      end)
    # IO.inspect li
    Compute.adjli(li)
    Compute.hashfun(li,reqli,num)
    Compute.mainFun(li, keyReqli)
    # IO.puts "Now we kill a random node"
    Bonus.updatePreSuc(Enum.at(li,0))
    Bonus.updateFingmap(Enum.at(li,0), li, keyReqli)
    loopfun(1)
  end

  def loopfun(1) do
    loopfun(1)
  end
end
