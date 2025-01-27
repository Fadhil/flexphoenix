defmodule Flexcility.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Flexcility.Web, :controller
      use Flexcility.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Arc.Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      alias Flexcility.Repo

      def put_user_id(changeset, user_id) do
        case changeset do
          %Ecto.Changeset{valid?: true} ->
            put_change(changeset, :user_id, user_id)
          _ ->
            changeset
        end
      end

      def last() do
        Repo.one(from x in __MODULE__, order_by: [desc: x.id], limit: 1)
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Flexcility.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import Flexcility.Router.Helpers
      import Flexcility.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 1, get_flash: 2, view_module: 1, action_name: 1, controller_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Flexcility.Router.Helpers
      import Flexcility.ErrorHelpers
      import Flexcility.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Flexcility.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      import Flexcility.Gettext
    end
  end

  def uploader do
    quote do
      use Arc.Definition
      use Arc.Ecto.Definition

      # def __storage do
      #   Arc.Storage.Local
      # end

      def storage_dir(version, {file, scope}) do
        "#{resource_name(scope)}/#{scope.id}"
      end

      def filename(version, {file, scope}) do
        "#{version}-#{file.file_name}"
      end

      defp resource_name(scope) do
        scope
        |> Map.get(:__struct__)
        |> Phoenix.Naming.resource_name
      end
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
