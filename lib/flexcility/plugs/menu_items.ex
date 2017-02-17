defmodule Flexcility.Plugs.MenuItems do
  import Plug.Conn
  alias Flexcility.Repo

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn

      _ ->
        assign_organisations(conn, user)

    end
  end

  def get_name_and_id(%{id: id, name: name}) do
    %{id: id, name: name}
  end

  # def assign_sites(conn, user) do
  #   user = user |> Repo.preload([{:sites, [{:requests, [:asset, :site]}]},
  #                                {:attached_sites, [{:requests, [:site, :asset]}]},
  #                                {:requests, [:site, :asset]},
  #                                {:assigned_orders, [{:request, [:site, :asset]}]}
  #                               ])
  #   own_sites = Enum.map(user.sites, &get_name_and_id/1)
  #   attached_sites = Enum.map(user.attached_sites, &get_name_and_id/1)
  #   assigned_requests = user.attached_sites |> Enum.map(fn proj -> proj.requests end) |> List.flatten
  #   assigned_orders = user.assigned_orders
  #   assign(conn, :own_sites, [])
  #   |> assign(:attached_sites, [])
  #   |> assign(:assigned_requests, [])
  #   |> assign(:assigned_orders, [])
  #   |> assign(:current_user, user)
  #
  # end

  def assign_organisations(conn, user) do
    user = user |> Repo.preload([:organisations])
    conn
  end
end
