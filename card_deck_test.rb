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
end

class CardDeck
  def initialize
    @cards = [].tap do |cards|
      %w(♠︎ ♣︎ ♥︎ ♦︎).each do |suite|
        %w(A 2 3 4 5 6 7 8 9 10 J Q K).each do |rank|
          cards << Card.new(suite, rank)
        end
      end
      2.times { cards << Card.new("*", "Joker") }
    end
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

  def ==(other_deck)
    cards_from_other_deck = []
    other_deck.each do |card|
      cards_from_other_deck << card
    end

    @cards == cards_from_other_deck
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
