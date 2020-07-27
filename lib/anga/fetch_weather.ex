defmodule Anga.FetchWeather do
  @moduledoc """
  Fetching the current the temperature from open weather api given the location.
  """
  @api_key Application.get_env(:anga, :api_key)

  @doc """
  HTTP get request to fetch weather data.
  """
  def fetch_weather(location) do
    url_builder(location)
    |> HTTPoison.get
    |> handle_response
  end

  @doc """
  URL_string builder
  """
  def url_builder(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{@api_key}"
  end


  @doc """
  Check if request was processed properly and parse the json body.
  """
  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!() |> fahreinheit_to_celsius

    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  @spec fahreinheit_to_celsius(nil | maybe_improper_list | map) :: float
  @doc """
  Convert the temperature to degree celsius
  """
  def fahreinheit_to_celsius(json) do
    json["main"]["temp"] - 273.15
    |> Float.round(1)
  end

  @doc """
  Fetching the temperatures concurrently.
  """
  def loop do
    receive do
      {sender_pid, location} -> send(sender_pid, fetch_weather(location))
      _ -> IO.puts "Don't know how to process this message."
    end
    # To ensure that the loop remains open even after processing the message.
    loop()
  end
end
