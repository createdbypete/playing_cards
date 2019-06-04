defmodule PlayingCards.CardDeck do
  alias PlayingCards.{CardDeck, Card}

  @cards (
           cards =
             for suit <- ~w(♠︎ ♣︎ ♥︎ ♦︎),
                 rank <- ~w(A 2 3 4 5 6 7 8 9 10 J Q K),
                 do: %Card{suit: suit, rank: rank}

           jokers = List.duplicate(%Card{suit: "*", rank: "Joker"}, 2)
           cards ++ jokers
         )

  @opaque t :: list(Card.t())
  @spec new() :: list()
  def new, do: @cards

  @spec size(CardDeck.t()) :: integer
  def size(deck) do
    length(deck)
  end

  @spec shuffle(CardDeck.t()) :: CardDeck.t()
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @spec draw(CardDeck.t()) :: {Card.t(), CardDeck.t()}
  def draw(deck) do
    List.pop_at(deck, 0)
  end

  @spec cut(CardDeck.t(), integer) :: {CardDeck.t(), CardDeck.t()}
  def cut(deck, num_of_cards) do
    Enum.split(deck, num_of_cards)
  end
end
