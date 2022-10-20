defmodule LiveViewStudioWeb.LoadingComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~L"""
      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>
    """
  end
end
