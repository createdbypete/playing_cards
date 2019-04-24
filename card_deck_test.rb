require "minitest/autorun"

class CardDeckTest < MiniTest::Test
  EXPECTED_NUMBER_OF_CARDS = 54
  def test_deck_has_correct_number_of_cards
    card_deck = CardDeck.new
    assert_equal EXPECTED_NUMBER_OF_CARDS, card_deck.size
  end
end

class CardDeck
  def size
    54
  end
end
