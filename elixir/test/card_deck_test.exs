defmodule PlayingCards.CardDeckTest do
  use ExUnit.Case, async: true

  alias PlayingCards.{CardDeck, Card}

  @expected_number_of_cards 54
  test "deck has correct number of cards" do
    deck = CardDeck.new()
    assert @expected_number_of_cards == CardDeck.size(deck)
  end

  @expected_cards_in_suite ~w(A 2 3 4 5 6 7 8 9 10 J Q K)
  @expected_cards %{
    "♠︎" => @expected_cards_in_suite,
    "♣︎" => @expected_cards_in_suite,
    "♥︎" => @expected_cards_in_suite,
    "♦︎" => @expected_cards_in_suite,
    "*" => ~w(Joker Joker)
  }

  test "it contains a full deck of cards" do
    deck = CardDeck.new()

    actual_cards =
      Enum.reduce(Enum.reverse(deck), %{}, fn %Card{suit: suit, rank: rank}, acc ->
        Map.update(acc, suit, [rank], &[rank | &1])
      end)

    assert @expected_cards == actual_cards
  end

  test "the deck is shuffled" do
    unshuffled_deck_1 = CardDeck.new()
    unshuffled_deck_2 = CardDeck.new()
    assert unshuffled_deck_1 == unshuffled_deck_2

    shuffled_deck_1 = CardDeck.new() |> CardDeck.shuffle()
    refute unshuffled_deck_1 == shuffled_deck_1

    shuffled_deck_2 = CardDeck.new() |> CardDeck.shuffle()
    refute shuffled_deck_1 == shuffled_deck_2
  end

  test "a card can be drawn from the deck" do
    deck = CardDeck.new() |> CardDeck.shuffle()
    {drawn_card, remaining_deck} = CardDeck.draw(deck)
    deck_size_after_draw = CardDeck.size(remaining_deck)

    assert @expected_number_of_cards - 1 == deck_size_after_draw

    Enum.each(remaining_deck, fn card ->
      refute card == drawn_card, "Drawn card found in remaining deck"
    end)
  end

  test "the deck can be cut" do
    deck = CardDeck.new()
    number_of_cards = 10
    size_of_right_cut = @expected_number_of_cards - number_of_cards

    {left, right} = CardDeck.cut(deck, number_of_cards)

    assert number_of_cards == CardDeck.size(left)
    assert size_of_right_cut == CardDeck.size(right)
  end

  test "a deck can be rejoined" do
    deck = CardDeck.new()
    number_of_cards = 10

    {left, right} = CardDeck.cut(deck, number_of_cards)
    assert deck == left ++ right
  end
end
