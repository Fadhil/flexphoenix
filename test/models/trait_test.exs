defmodule Flexcility.TraitTest do
  use Flexcility.ModelCase

  alias Flexcility.Trait

  @valid_attrs %{abbreviation: "some content", code: "some content", name: "some content"}
  @invalid_attrs %{}

  def create_traits do
    for i <- [1, 2, 3] do
      %Trait{name: "Trait #{i}", code: "trt#{i}", abbreviation: "t#{i}"}
      |> Repo.insert!
    end

    :ok
  end

  test "changeset with valid attributes" do
    changeset = Trait.changeset(%Trait{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Trait.changeset(%Trait{}, @invalid_attrs)
    refute changeset.valid?
  end

  test ".all with valid ids" do
    assert :ok = create_traits()
    assert [%Trait{id: trait1_id}, %Trait{id: trait2_id}, %Trait{id: trait3_id}] =
     Repo.all(Trait)
    traits = Trait.all([trait1_id, trait3_id])
    IO.puts inspect(traits)
    assert [%Trait{id: trait1_id}, %Trait{id: trait3_id}] = traits
  end
end
