# frozen_string_literal: true
require "minitest/autorun"

class CardDeckTest < MiniTest::Test
  EXPECTED_NUMBER_OF_CARDS = 54
  def test_deck_has_correct_number_of_cards
    card_deck = CardDeck.new
    assert_equal EXPECTED_NUMBER_OF_CARDS, card_deck.size
  end

  EXPECTED_CARDS_IN_SUITE = %w(A 2 3 4 5 6 7 8 9 10 J Q K).freeze
  EXPECTED_CARDS = {
    "♠︎" => EXPECTED_CARDS_IN_SUITE,
    "♣︎" => EXPECTED_CARDS_IN_SUITE,
    "♥︎" => EXPECTED_CARDS_IN_SUITE,
    "♦︎" => EXPECTED_CARDS_IN_SUITE,
    "*" => %w(Joker Joker).freeze,
  }.freeze

  def test_it_contins_a_full_deck_of_cards
    card_deck = CardDeck.new
    actual_cards = Hash.new { |hsh, key| hsh[key] = [] }
    card_deck.each do |card|
      actual_cards[card.suite] << card.rank
    end

    assert_equal EXPECTED_CARDS, actual_cards
  end

  def test_the_deck_is_shuffled
    unshuffled_deck_1 = CardDeck.new
    unshuffled_deck_2 = CardDeck.new
    assert_equal unshuffled_deck_1, unshuffled_deck_2

    shuffled_deck_1 = CardDeck.new.shuffle!
    refute_equal unshuffled_deck_1, shuffled_deck_1

    shuffled_deck_2 = CardDeck.new.shuffle!
    refute_equal shuffled_deck_1, shuffled_deck_2
  end

  def test_a_card_can_be_drawn_from_the_deck
    card_deck = CardDeck.new.shuffle!
    drawn_card = card_deck.draw!
    deck_size_after_draw = card_deck.size

    assert_equal (EXPECTED_NUMBER_OF_CARDS - 1), deck_size_after_draw

    card_deck.each do |card|
      refute_equal card, drawn_card, "Drawn card found in remaining deck"
    end
  end

  def test_deck_can_be_cut
    card_deck = CardDeck.new
    number_of_cards = 10
    size_of_right_cut = (EXPECTED_NUMBER_OF_CARDS - number_of_cards)

    left, right = *card_deck.cut!(number_of_cards)

    assert_equal number_of_cards, left.size
    assert_equal size_of_right_cut, right.size
  end

  def test_a_cut_deck_can_be_rejoined
    card_deck = CardDeck.new
    number_of_cards = 10

    left, right = *card_deck.cut!(number_of_cards)
    assert_equal card_deck, (left + right)
  end
end

class CardDeck
  def initialize(cards = build_cards)
    @cards = cards
  end

  def each(&block)
    @cards.each(&block)
  end

  def size
    @cards.size
  end

  def shuffle!
    @cards.shuffle!
    self
  end

  def draw!
    @cards.shift
  end

  def cut!(num_of_cards)
    [
      CardDeck.new(@cards[0, num_of_cards]),
      CardDeck.new(@cards[num_of_cards, @cards.size])
    ]
  end

  def +(other_deck)
    cards_from_other = []
    other_deck.each do |card|
      cards_from_other << card
    end

    CardDeck.new(@cards + cards_from_other)
  end

  def ==(other_deck)
    cards_from_other_deck = []
    other_deck.each do |card|
      cards_from_other_deck << card
    end

    @cards == cards_from_other_deck
  end

  private

  def build_cards
    [].tap do |cards|
      %w(♠︎ ♣︎ ♥︎ ♦︎).each do |suite|
        %w(A 2 3 4 5 6 7 8 9 10 J Q K).each do |rank|
          cards << Card.new(suite, rank)
        end
      end
      2.times { cards << Card.new("*", "Joker") }
    end
  end
end

class Card
  attr_reader :suite, :rank

  def initialize(suite, rank)
    @suite = suite
    @rank = rank
  end

  def ==(other)
    suite == other.suite && rank == other.rank
  end
end
