defmodule ClockkIntegrationPlug.ClockkResource do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn
    |> put_action_resource(opts)
    |> put_intergration_performed_actions(opts)
    |> put_clockk_customer_id(opts)
  end

  defp put_action_resource(conn, _) do
    resource_json = conn.params["resource"]

    clockk_resource =
      if resource_json do
        Jason.decode!(resource_json, keys: :atoms)
      else
        nil
      end

    Plug.Conn.put_private(conn, :clockk_resource, clockk_resource)
  end

  defp put_intergration_performed_actions(conn, _) do
    if conn.private.clockk_resource do
      Plug.Conn.put_private(
        conn,
        :integration_performed_actions,
        List.first(conn.private.clockk_resource.integration_performed_actions)
      )
    else
      conn
    end
  end

  defp put_clockk_customer_id(conn, _) do
    clockk_customer_id = conn.query_params["clockk_customer_id"]
    Plug.Conn.put_private(conn, :clockk_customer_id, clockk_customer_id)
  end
end
