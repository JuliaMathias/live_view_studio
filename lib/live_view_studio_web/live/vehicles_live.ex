defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    {:ok, assign(socket, total_vehicles: Vehicles.count_vehicles()),
     temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    vehicles = Vehicles.list_vehicles(paginate: paginate_options, sort: sort_options)

    socket =
      assign(socket,
        options: Map.merge(paginate_options, sort_options),
        vehicles: vehicles
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: socket.assigns.options.page,
            per_page: per_page,
            sort_by: socket.assigns.options.sort_by,
            sort_order: socket.assigns.options.sort_order
          )
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>🚙 Vehicles 🚘</h1>
    <div id="vehicles">
      <form phx-change="select-per-page">
        Show
        <select name="per-page">
          <%= options_for_select([5, 10, 15, 20], @options.per_page) %>
        </select>
        <label for="per-page">per page</label>
      </form>
      <div class="wrapper">
        <table>
          <thead>
            <tr>
              <th>
                <%= sort_link(@socket, "ID", :id, @options) %>
              </th>
              <th>
                <%= sort_link(@socket, "Make", :make, @options) %>
              </th>
              <th>
                <%= sort_link(@socket, "Model", :model, @options) %>
              </th>
              <th>
                <%= sort_link(@socket, "Color", :color, @options) %>
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for vehicle <- @vehicles do %>
              <tr>
                <td>
                  <%= vehicle.id %>
                </td>
                <td>
                  <%= vehicle.make %>
                </td>
                <td>
                  <%= vehicle.model %>
                </td>
                <td>
                  <%= vehicle.color %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        <div class="footer">
          <div class="pagination">
        <%= if @options.page > 1 do %>
          <%= pagination_link(@socket,
                              "Previous",
                              @options.page - 1,
                              @options,
                              "previous") %>
        <% end %>
        <%= for i <- (@options.page - 2)..(@options.page + 2), i > 0 do %>
          <%= if i <= ceil(@total_vehicles / @options.per_page) do %>
            <%= pagination_link(@socket,
                                  i,
                                  i,
                                  @options,
                                  (if i == @options.page, do: "active")) %>
          <% end %>
        <% end %>
        <%= if (@options.page * @options.per_page) < @total_vehicles do %>
          <%= pagination_link(@socket,
                              "Next",
                              @options.page + 1,
                              @options,
                              "next") %>
        <% end %>
      </div>
        </div>
      </div>
    </div>
    """
  end

  defp pagination_link(socket, text, page, options, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        ),
      class: class
    )
  end

  defp sort_link(socket, text, sort_by, options) do
    text =
      if sort_by == options.sort_by do
        text <> emoji(options.sort_order)
      else
        text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp emoji(:asc), do: " ⬇"
  defp emoji(:desc), do: " ⬆"
end
