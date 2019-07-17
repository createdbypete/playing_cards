class CardDeck(private val cards: MutableList<Card> = mutableListOf()) : Iterable<Card> {
    init {
        if (cards.isEmpty()) {
            val suites = listOf(Suite.CLUBS, Suite.DIAMONDS, Suite.HEARTS, Suite.SPADES)
            val ranks = listOf(Rank.ACE, Rank.TWO, Rank.THREE, Rank.FOUR, Rank.FIVE, Rank.SIX, Rank.SEVEN, Rank.EIGHT, Rank.NINE, Rank.TEN, Rank.JACK, Rank.QUEEN, Rank.KING)

            for (suite in suites) {
                for (rank in ranks) {
                    cards.add(Card(suite, rank))
                }
            }

            cards.add(Card(Suite.WILD, Rank.JOKER))
            cards.add(Card(Suite.WILD, Rank.JOKER))
        }
    }



    override fun equals(other: Any?): Boolean {
        return when(other) {
            is CardDeck -> {
                val otherCards = other.fold(mutableListOf<Card>()) { acc, card ->
                    acc.add(card)
                    acc
                }
                return cards == otherCards
            }
            else -> super.equals(other)
        }
    }

    override fun iterator() = cards.iterator()
    fun size() = cards.size
    fun shuffle(): CardDeck {
        cards.shuffle()
        return this
    }

    fun draw(): Card {
        return cards.removeAt(0)
    }

    fun cut(numberOfCards: Int): Pair<CardDeck,CardDeck> {
        return Pair(
            CardDeck(cards.take(numberOfCards).toMutableList()),
            CardDeck(cards.drop(numberOfCards).toMutableList())
        )
    }

    fun join(otherDeck: CardDeck): CardDeck {
        otherDeck.forEach{ card ->
            cards.add(card)
        }

        return this
    }
}

