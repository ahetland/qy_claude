defmodule QyClaude do
  @moduledoc """
  Claude GenServer
  """
  @me __MODULE__
  @timeout 60_000
  
  @opus "claude-3-opus-20240229"
  @sonnet "claude-3-5-sonnet-20240620"

  use GenServer

  @impl true
  def init(_) do
    key = System.get_env "ALEX_KEY_TO_CLUADE"
    client = Anthropix.init(key)
    #client = :a_claude_cli
    history = [] #messages()

    {:ok, {client, history}}
  end

  @impl true
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @me)
  end

  def chat(message) do
    GenServer.call(@me, {:chat, message}, @timeout)
  end

  def messages() do
    lst = GenServer.call(@me, :messages)
  end

  def handle_call(:messages, _from, state) do
    {client, history} = state
    {:reply, history, state}
  end

  @impl true
  def handle_call({:chat, new_message}, _from, {client, msg} = state) do
    new_msg = %{role: "user", content: new_message}
    new_msg_list = msg ++ [new_msg]
    answer = Anthropix.chat(client, [model: @opus, messages: new_msg_list])

    {:ok, %{"content" => [h | t]}} = answer
    %{"text" => new_answer} = h

    #new_answer = %{role: "assistant", content: "answer to question"}
    new_answer = %{role: "assistant", content: new_answer}

    new_msg_list = new_msg_list ++ [new_answer]
    new_state = {client, new_msg_list}
    {:reply, new_answer, new_state}
  end
end
