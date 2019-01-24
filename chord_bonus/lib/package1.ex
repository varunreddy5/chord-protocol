defmodule Package1 do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, :ok, [])
    end

    def init(:ok) do
        {:ok, {0,0,[],%{}}}
    end

    def processIndex(pid, x) do
        GenServer.cast(pid, {:processId, x})
    end

    def handle_cast({:processId, x}, state) do
        {id,count,spli,fingmap} = state
        state={x,count,spli,fingmap}
        #IO.puts x
        {:noreply, state}
    end

    def curNodeId(pid) do
        GenServer.call(pid, {:curId})
    end

    def handle_call({:curId}, _from, state) do
        id=elem(state,0)
        {:reply, id, state}
    end

    def procHopcount(pid, nodehop) do
        GenServer.cast(pid, {:processHop, nodehop})
    end

    def handle_cast({:processHop, nodehop}, state) do
        {id,count,spli,fingmap} = state
        state={id,nodehop,spli,fingmap}
        #IO.puts "current hop count: #{nodehop}"
        {:noreply, state}
    end

    def curHopcount(pid) do
        GenServer.call(pid, {:hopCount})
    end

    def handle_call({:hopCount}, _from, state) do
        hops=elem(state,1)
        #IO.puts "in call: #{hops}"
        {:reply, hops, state}
    end

    def adjNodeLi(pid, adjList) do
        GenServer.cast(pid, {:adjNodeList, adjList})
    end

    def handle_cast({:adjNodeList, adjList}, state) do
        {id,count,spli,fingmap} = state
        state = {id, count, adjList, fingmap}
        #IO.inspect adjList
        {:noreply, state}
    end

    def curAdjli(pid) do
        GenServer.call(pid, {:curAdj})
    end

    def handle_call({:curAdj}, _from, state) do
        li=elem(state,2)
        {:reply, li, state}
    end

    def processFinmap(pid, x) do
        GenServer.cast(pid, {:processFin, x})
    end

    def handle_cast({:processFin, x}, state) do
        {id,count,spli,fingmap} = state
        state={id,count,spli,x}
        #IO.inspect x
        {:noreply, state}
    end

    def curFinmap(pid) do
        GenServer.call(pid, {:curFin})
    end

    def handle_call({:curFin}, _from, state) do
        finmap=elem(state,3)
        {:reply, finmap, state}
    end

    def keyFun(nodeele, keyReqli) do
        GenServer.cast(nodeele, {:keysHop, keyReqli})
        :timer.sleep(50)
        nodeHopSum = curHopcount(nodeele)
        # IO.puts "in keyfun : #{nodeHopSum}"
        nodeHopSum
    end

    def handle_cast({:keysHop, keyReqli}, state) do
        #finmap=elem(state,3)
        # IO.puts "in key call"
        # pid=self()
        # IO.inspect pid
        {id,count,spli,fingmap} = state
        keyHopsli=Enum.map(keyReqli, fn(key) ->

                    #Process.send_after(self, :sl, 100)
                    hop=Compute.findKey(id, fingmap, key, 0)
                    #IO.puts "hops are: #{hop}"
                    hop
                  end)
        procHopcount(self(), Enum.sum(keyHopsli))
        {:noreply, state}
    end

    def killfun(pid) do
      IO.puts("#{inspect(pid)} Process exited")
        send(pid, :sl)
    end

    def handle_info(:sl, state) do
        # IO.puts "Process exited"
        {:stop, :normal, state}
    end
end
