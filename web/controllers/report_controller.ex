defmodule Flexphoenix.ReportController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Report
  alias Flexphoenix.Order
  alias Flexphoenix.Request

  plug :scrub_params, "report" when action in [:create, :update]

  def index(
    %{assigns: %{current_user: current_user}}=conn, _params
  ) do
    user = current_user |> Repo.preload([:reports])
    reports = user.reports
    render(conn, "index.html", reports: reports)
  end

  def new(conn, _params) do
    changeset = Report.changeset(%Report{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"report" => report_params}) do
    current_user = conn.assigns.current_user
    current_order = conn.assigns.current_order
    changeset = Report.changeset(%Report{}, current_user.id, current_order.id, report_params)

    case Repo.insert(changeset) do
      {:ok, _report} ->
        conn
        |> put_flash(:info, "Report created successfully.")
        |> redirect(to: report_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Repo.get!(Report, id)
    report = Report |> Report.with_owner |> Repo.get!(id)
    render(conn, "show.html", report: report)
  end

  def edit(conn, %{"id" => id}) do
    report = Repo.get!(Report, id)
    changeset = Report.changeset(report)
    render(conn, "edit.html", report: report, changeset: changeset)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Repo.get!(Report, id)
    changeset = Report.changeset(report, report_params)

    case Repo.update(changeset) do
      {:ok, report} ->
        conn
        |> put_flash(:info, "Report updated successfully.")
        |> redirect(to: report_path(conn, :show, report))
      {:error, changeset} ->
        render(conn, "edit.html", report: report, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Repo.get!(Report, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(report)

    conn
    |> put_flash(:info, "Report deleted successfully.")
    |> redirect(to: report_path(conn, :index))
  end
end
