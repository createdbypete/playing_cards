defmodule PlayingCards.Card do
  defstruct [:suit, :rank]

  @type t(suit, rank) :: %PlayingCards.Card{suit: suit, rank: rank}
  @type t :: %PlayingCards.Card{suit: String.t(), rank: String.t()}
end
