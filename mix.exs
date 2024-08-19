defmodule QyClaude.MixProject do
  use Mix.Project

  def project do
    [
      app: :qy_claude,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {QyClaude.Application, []}
    ]
  end

  defp deps do
    [
      {:anthropix, "~> 0.3.1"},
      {:ex_prompt, "~> 0.2.0"}
    ]
  end
end
