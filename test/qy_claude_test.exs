defmodule QyClaudeTest do
  use ExUnit.Case
  doctest QyClaude

  test "greets the world" do
    assert QyClaude.hello() == :world
  end
end
