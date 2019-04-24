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
end

class Card
  attr_reader :suite, :rank

  def initialize(suite, rank)
    @suite = suite
    @rank = rank
  end
end
