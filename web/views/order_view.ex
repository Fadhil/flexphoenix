defmodule Flexcility.OrderView do
  use Flexcility.Web, :view
  import Flexcility.RequestView, only: [asset_name: 1, project_name: 1]
  import Flexcility.LayoutView, only: [display_name: 1, image: 1, profile_image: 1]

  # Takes a users_roles struct that has role.name = "Admin" and returns
  # %{user: <the matched user>, role: "Admin"}
  def admins(%{role: %{name: "Admin"}, user: admin}) do
      %{user: admin, role: "Admin"}
  end

  def admins(_) do
    []
  end

  def technicians(technician) do
      %{user: technician, role: "Technician"}
  end

  def technicians(_) do
    []
  end

  # Calls `admins` from above to get a list of admins and roles,
  # i.e. [%{user: <admin struct>, role: "Admin"}]
  def admins_with_roles(project_roles) do
    project_roles
    |> Enum.map(&admins/1)
  end

  # All orders/requests have an owner, so we don't ned to match for _
  # like technicians and admins
  def owner_with_roles(owner) do
    %{user: owner, role: "Requestor"}
  end

  # Sites also MUST have owner, so no need to match for _
  def project_owner_with_roles(project_owner) do
    %{user: project_owner, role: "Site Owner"}
  end

  # Calls `technicians` to get a  list of technicians and roles,
  # i.e. [%{user: <admin struct>, role: "Technician"}]
  def technicians_with_roles(assigned_technicians) do
    assigned_technicians
    |> Enum.map(&technicians/1)
  end

  @doc ~S"""
  Returns a map of users and roles, grouped by user.
  Looks like this:
   %{<user A> => [%{user: <user A>, role: "Admin"}],
     <User B> => [%{user: <User B>, role: "Admin"},
                  %{user: <User B>, role: "Technician"}],
     <User C> => [%{user: <User C, role: "Client"}]
     ... and so on
    }


    Note: a fully preloaded user struct with no associations looks like this:
    %Flexcility.User{__meta__: #Ecto.Schema.Metadata<:loaded>,
     assigned_orders: [],
     assigned_requests: []>,
     assigned_technicians: [],
     attached_sites: [],
     email: "fadhil@jomcode.com", first_name: "Fadhil", id: 3,
     inserted_at: #Ecto.DateTime<2016-07-26T15:56:24Z>, last_name: "Luqman",
     orders: []>,
     password: nil, password_confirmation: nil,
     password_hash: "$2b$12$3kX9.T4nOinKtD6buN0G8.N2YCQXmBfDa.gJSlLjNrE8iZDLnUzzq",
     sites: []>,
     reports: [],
     requests: [],
     roles: [],
     updated_at: #Ecto.DateTime<2016-07-28T04:12:06Z>,
     users_roles: []}
  """
  def members_and_roles(%{user: owner,
                          technicians: assigned_technicians,
                          request: %{
                            site: %{
                              user: project_owner,
                              users_roles: project_roles                            }
                          }
                        }) do # Here we match an order that's been preloaded
                              # with these associations

    # Now we put them together and flatten them, and then group by user struct
    members = [admins_with_roles(project_roles),
               owner_with_roles(owner),
               project_owner_with_roles(project_owner),
               technicians_with_roles(assigned_technicians)
              ]
              |> List.flatten
              |> Enum.group_by(fn m -> m.user end)
  end

  # Gets a list or user and roles,
  #  e.g. [{user: <user A>, role: "Admin"},
  #        {user: <user A>, role: "Technician"}]
  # and returns all the roles in a comma separated list, e.g. "Admin, Technician"
  def display_roles(member_roles) do
    member_roles
    |> Enum.map(fn mr -> mr.role end)
    |> Enum.join(",")
  end
end
