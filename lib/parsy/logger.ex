defmodule Parsy.Logger do
  @moduledoc """
  The custom logger for Parsy.
  """

  require Logger

  @doc """
  The basic log function. It logs to debug level if config is enabled.
  """
  @spec log(binary) :: :ok
  def log(message) do
    if Application.get_env(:parsy, :debug) do
      Logger.debug(message)
    end

    :ok
  end
end
