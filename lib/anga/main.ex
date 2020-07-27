defmodule Anga do
  def fetch_cities_weather(cities) do
    coordinator_pid = spawn(Anga.Coordinator, :loop, [[], Enum.count(cities)])

    cities
    |> Enum.each(fn city ->
      worker_pid = spawn(Anga.FetchWeather, :loop, [])
      send(worker_pid, {coordinator_pid, city})
    end)
  end
end
