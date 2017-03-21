alias Flexcility.{Repo, Role, Facility, Trait}

IO.puts "Creating Roles"
admin_role = case Repo.get_by(Role, name: "Admin") do
  nil -> Repo.insert! %Role{name: "Admin"}
  role -> role
end

technician_role = case Repo.get_by(Role, name: "Technician") do
  nil -> Repo.insert! %Role{name: "Technician"}
  role -> role
end

tenant_role = case Repo.get_by(Role, name: "Tenant") do
  nil -> Repo.insert! %Role{name: "Tenant"}
  role -> role
end

engineer_role = case Repo.get_by(Role, name: "Engineer") do
  nil -> Repo.insert! %Role{name: "Engineer"}
  role -> role
end

helpdesk_role = case Repo.get_by(Role, name: "Helpdesk") do
  nil -> Repo.insert! %Role{name: "Helpdesk"}
  role -> role
end

##
# Facilities
##
facilities_list = [
  {"Schools", "icon-graduation-cap"}, {"Commercial Buildings", "icon-commercial-building"},
  {"Industrial Buildings", "icon-industrial-building"}, {"Apartments/ Condos", "icon-building"},
  {"Hospitals", "icon-h-sign"}
]

IO.puts "Creating Default Facility Types"
facilities_list |> Enum.each(fn({name, icon}) ->
 case Repo.get_by(Facility, name: name, icon_name: icon) do
   nil -> Repo.insert! %Facility{name: name, icon_name: icon}
   facility -> IO.puts "Skipping existing facility type #{facility.name}"
 end
end)
##
# End Facilities
##


##
# Default Traits
# #
traits_list = [
  {"Mechanical Engineering", "1", "M"}, {"Electrical Engineering", "2", "E"},
  {"Civil Engineering", "3", "C"}, {"Housekeeping", "4", "HSK"},
  {"Information Technology", "5", "IT"}, {"Security Services", "6", "SEC"},
  {"Event Management", "7", "EM"}
]

traits_list |> Enum.each(fn({name, code, abbrev}) ->
  case Repo.get_by(Trait, name: name, code: code, abbreviation: abbrev) do
    nil -> Repo.insert! %Trait{name: name, code: code, abbreviation: abbrev}
    trait -> IO.puts "Skipping existing trait #{trait.name}"
  end
end)
##
# End Default Traits
# #

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Flexcility.Repo.insert!(%Flexcility.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
