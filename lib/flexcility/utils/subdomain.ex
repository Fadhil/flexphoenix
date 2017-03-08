defmodule Flexcility.Utils.Subdomain do
  def prepend(url, subdomain) do
    flexcility_host = Flexcility.Endpoint.config(:url)[:host]
    url |> String.replace(flexcility_host,
                          subdomain <> ".",
                          insert_replaced: String.length(subdomain <> "."))
  end
end
