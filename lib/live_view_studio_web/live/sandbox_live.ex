defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.DeliveryChargeComponent
  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudioWeb.SandboxCalculatorComponent

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weight: nil, price: nil, charge: 0)}
  end

  def render(assigns) do
    ~L"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <%= live_component @socket, SandboxCalculatorComponent, id: 1, coupon: 10.0 %>

      <%= if @weight do %>
        <%= live_component @socket, DeliveryChargeComponent, id: 2 %>
        <%= live_component @socket, QuoteComponent,
                          material: "sand",
                          weight: @weight,
                          price: @price,
                          charge: @charge %>
      <% end %>
    </div>
    """
  end

  def handle_info({:totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)
    {:noreply, socket}
  end

  def handle_info({:charge, charge}, socket) do
    socket = assign(socket, charge: charge)
    {:noreply, socket}
  end
end
