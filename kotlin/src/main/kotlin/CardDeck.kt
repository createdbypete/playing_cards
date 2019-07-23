class CardDeck private constructor(private val cards: List<Card>) : Iterable<Card> {
    companion object {
        fun build(): CardDeck {
            val cards = mutableListOf<Card>()
            val suites = setOf(Suite.CLUBS, Suite.DIAMONDS, Suite.HEARTS, Suite.SPADES)
            val ranks = setOf(
                Rank.ACE, Rank.TWO, Rank.THREE, Rank.FOUR, Rank.FIVE, Rank.SIX, Rank.SEVEN,
                Rank.EIGHT, Rank.NINE, Rank.TEN, Rank.JACK, Rank.QUEEN, Rank.KING
            )

            for (suite in suites) {
                for (rank in ranks) {
                    cards.add(Card(suite, rank))
                }
            }

            cards.add(Card(Suite.WILD, Rank.JOKER))
            cards.add(Card(Suite.WILD, Rank.JOKER))

            return CardDeck(cards)
        }
    }

    override fun equals(other: Any?): Boolean = when {
        other is CardDeck -> cards == other.cards
        else -> super.equals(other)
    }

    override fun iterator() = cards.iterator()
    override fun hashCode() = cards.hashCode()

    fun size() = cards.size

    fun shuffle(): CardDeck {
        return CardDeck(
            cards.toMutableList()
                .apply { shuffle() }
        )
    }

    fun draw(): Pair<Card, CardDeck> {
        val remainingCards = cards.toMutableList()
        val drawnCard = remainingCards.removeAt(0)
        return drawnCard to CardDeck(remainingCards)
    }

    fun cut(numberOfCards: Int) = Pair(
        CardDeck(cards.take(numberOfCards)),
        CardDeck(cards.drop(numberOfCards))
    )

    operator fun plus(otherDeck: CardDeck): CardDeck {
        return CardDeck(
            cards.toMutableList()
                .apply { addAll(otherDeck) }
        )
    }
}
