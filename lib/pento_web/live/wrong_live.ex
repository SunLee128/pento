defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias Pento.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess:",
        session_id: session["live_socket_id"],
        current_user: Pento.Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1> your score: <%= @score %> </h1>
    <h2><%= @message %>It's <%= time()%></h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def time do
    DateTime.utc_now |> to_string
  end

  def handle_event("guess", %{ "number" => guess}=data, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again."
    score = socket.assigns.score - 1
    {:noreply, assign(socket, score: score, message: message)}
  end
end
