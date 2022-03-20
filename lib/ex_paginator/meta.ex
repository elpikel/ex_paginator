defmodule ExPaginator.Meta do
  defstruct entries: [], total: 0, cursor: ""

  def decode(nil), do: nil

  def decode(encoded_cursor) do
    encoded_cursor
    |> Base.url_decode64!()
    |> Plug.Crypto.non_executable_binary_to_term([:safe])
  end

  def encode(values) do
    values
    |> :erlang.term_to_binary()
    |> Base.url_encode64()
  end
end
