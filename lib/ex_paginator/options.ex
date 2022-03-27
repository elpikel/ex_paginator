defmodule ExPaginator.Options do
  defstruct fields: [], limit: 0, cursor: nil, cursor_function: nil, direction: :forward

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
