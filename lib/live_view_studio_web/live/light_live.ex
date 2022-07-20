defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temp: 3000)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="background-color: <%= temp_color(@temp) %>; width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg">
        <span class="sr-only">Off</span>
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
        <span class="sr-only">Down</span>
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
        <span class="sr-only">Up</span>
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
        <span class="sr-only">On</span>
      </button>

      <div id="license" style="margin-top: 3rem">
        <div class="card">
          <div class="content">
            <div id="seats" class="seats">
              <span>
                The brightness is currently
                <strong><%= @brightness %></strong>.
              </span>
            </div>

            <form id="update-brightness" phx-change="update">
              <input type="range" min="1" max="100"
                    name="brightness" value="<%= @brightness %>"  />

              <p style="margin-top: 1rem !important; --tw-text-opacity: 1; color: rgba(54, 65, 82, var(--tw-text-opacity))">
              <b>Temperature<b/>:&nbsp;
              <input type="radio" id="3000" name="temp" value="3000"
                <%= if 3000 == @temp, do: "checked" %> />
              <label for="3000">warm</label>

              <input type="radio" id="4000" name="temp" value="4000"
                <%= if 4000 == @temp, do: "checked" %> />
              <label for="4000">cool</label>

              <input type="radio"id="5000" name="temp" value="5000"
                <%= if 5000 == @temp, do: "checked" %> />
              <label for="5000">daylight</label>
              </p>
            </form>
          </div>
        </div>
      </div>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness, "temp" => temp}, socket) do
    brightness = String.to_integer(brightness)
    temp = String.to_integer(temp)

    socket = assign(socket, brightness: brightness, temp: temp)

    {:noreply, socket}
  end

  defp temp_color(3000), do: "#F1C40D"
  defp temp_color(4000), do: "#FEFF66"
  defp temp_color(5000), do: "#99CCFF"
end
