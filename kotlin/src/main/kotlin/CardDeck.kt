class CardDeck(vararg cards: Card) : Iterable<Card> {
    private val _cards: MutableList<Card> = cards.toMutableList()

    companion object {
        fun build(): CardDeck {
            val cards = mutableListOf<Card>()
            val suites = setOf(Suite.CLUBS, Suite.DIAMONDS, Suite.HEARTS, Suite.SPADES)
            val ranks = setOf(Rank.ACE, Rank.TWO, Rank.THREE, Rank.FOUR, Rank.FIVE, Rank.SIX, Rank.SEVEN, Rank.EIGHT, Rank.NINE, Rank.TEN, Rank.JACK, Rank.QUEEN, Rank.KING)

            for (suite in suites) {
                for (rank in ranks) {
                    cards.add(Card(suite, rank))
                }
            }

            cards.add(Card(Suite.WILD, Rank.JOKER))
            cards.add(Card(Suite.WILD, Rank.JOKER))

            return CardDeck(*cards.toTypedArray())
        }
    }

    override fun equals(other: Any?): Boolean {
        return when(other) {
            is CardDeck -> {
                val otherCards = other.fold(mutableListOf<Card>()) { acc, card ->
                    acc.add(card)
                    acc
                }
                return _cards == otherCards
            }
            else -> super.equals(other)
        }
    }

    override fun iterator() = _cards.iterator()
    override fun hashCode() = _cards.hashCode()

    fun size() = _cards.size

    fun shuffle(): CardDeck {
        _cards.shuffle()
        return this
    }

    fun draw() = _cards.removeAt(0)

    fun cut(numberOfCards: Int) = Pair(
            CardDeck(*_cards.take(numberOfCards).toTypedArray()),
            CardDeck(*_cards.drop(numberOfCards).toTypedArray())
        )

    operator fun plus(otherDeck: CardDeck): CardDeck {
        for (card in otherDeck) {
            _cards.add(card)
        }

        return this
    }
}

