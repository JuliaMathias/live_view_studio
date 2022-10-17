defmodule LiveViewStudioWeb.DeliveryChargeComponent do
  use LiveViewStudioWeb, :live_component

  import Number.Currency

  alias LiveViewStudio.SandboxCalculator

  def mount(socket) do
    {:ok, assign(socket, charge: 0, zip: nil)}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="calculate" phx-target="<%= @myself %>">
      <div class="field">
        <label for="zip">Zip Code:</label>
        <input type="text" name="zip" value="<%= @zip %>" />
        <span class="unit"><%= number_to_currency(@charge) %></span>
      </div>
    </form>
    """
  end

  def handle_event("calculate", %{"zip" => zip}, socket) do
    charge = SandboxCalculator.calculate_delivery_charge(zip)

    socket =
      assign(socket,
        zip: zip,
        charge: charge
      )

    send(self(), {:charge, charge})

    {:noreply, socket}
  end
end
