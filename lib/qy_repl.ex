defmodule QyClaude.QyREPL do
  def start do
    loop()
  end

  defp loop do
    input = IO.gets("Ask Claude> ")
    handle_input(input)
    loop()
  end

  defp handle_input(:eof), do: exit(:shutdown)

  defp handle_input(input) do
    input = String.trim(input)
    
    pp_hist = 
      fn %{role: role, content: m} -> 
        case role do
          "user" ->
            IO.puts(IO.ANSI.cyan() <> "#{m}" <> IO.ANSI.reset())
          _ -> 
            IO.puts(IO.ANSI.yellow() <> "#{m}" <> IO.ANSI.reset()) 
        end
      end

    try do
      cond do
        input == ":history" -> QyClaude.messages
          answer = QyClaude.messages
          Enum.each(answer, &(pp_hist.(&1)))
        input == "history" -> 
          answer = QyClaude.messages
          Enum.each(answer, &(pp_hist.(&1)))
        true -> 
          %{content: answer} = QyClaude.chat(input)
          IO.puts(IO.ANSI.green() <> "#{answer}" <> IO.ANSI.reset())
      end
    rescue
      e -> IO.puts("Error: #{inspect(e)}")
    end
  end

end
