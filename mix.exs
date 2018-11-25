defmodule Factor18.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      groups_for_modules: [
        "Composer": [Composer, Composer.AST, Composer.DSL],
        "LightBridge": [LightBridge, LightBridge.Component, LightBridge.Instance, LightBridge.Workflow],
        "Seeker": [Seeker, Seeker.Executor, Seeker.Flow.Component, Seeker.Flow.Workflow,
          SeekerWeb.ComponentController, SeekerWeb.Router.Helpers, SeekerWeb.WorkflowController]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:ex_doc, "~> 0.18.0", only: :dev, runtime: false}]
  end
end
