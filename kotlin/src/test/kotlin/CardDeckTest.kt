import org.junit.jupiter.api.Test

class CardDeckTest {
    private val expectedNumberOfCards = 54

    @Test
    fun `deck has correct number of cards`() {
        val cardDeck = CardDeck()
        assert(expectedNumberOfCards == cardDeck.size())
    }

    private val expectedCardsInSuite = listOf(
        Rank.ACE, Rank.TWO, Rank.THREE, Rank.FOUR, Rank.FIVE, Rank.SIX, Rank.SEVEN,
        Rank.EIGHT, Rank.NINE, Rank.TEN, Rank.JACK, Rank.QUEEN, Rank.KING
    )

    private val expectedCards = mapOf(
        Suite.SPADES   to expectedCardsInSuite,
        Suite.CLUBS    to expectedCardsInSuite,
        Suite.HEARTS   to expectedCardsInSuite,
        Suite.DIAMONDS to expectedCardsInSuite,
        Suite.WILD     to listOf(Rank.JOKER, Rank.JOKER)
    )

    @Test
    fun `it contains a full deck of cards`() {
        val cardDeck = CardDeck()
        val actualCards = cardDeck.fold(mutableMapOf<Suite, MutableList<Rank>>()) { actualCards, card ->
            actualCards.getOrPut(card.suite, ::mutableListOf).add(card.rank)
            actualCards
        }
        assert(expectedCards == actualCards)
    }

    @Test
    fun `the deck is shuffled`() {
        val unshuffledDeck1 = CardDeck()
        val unshuffledDeck2 = CardDeck()
        assert(unshuffledDeck1 == unshuffledDeck2)

        val shuffledDeck1 = CardDeck().shuffle()
        assert(unshuffledDeck1 != shuffledDeck1)

        val shuffledDeck2 = CardDeck().shuffle()
        assert(shuffledDeck1 != shuffledDeck2)
    }

    @Test
    fun `a card can be drawn from the deck`() {
        val cardDeck = CardDeck().shuffle()
        val drawnCard = cardDeck.draw()
        val deckSizeAfterDraw = cardDeck.size()

        assert((expectedNumberOfCards - 1) == deckSizeAfterDraw)

        cardDeck.forEach { card ->
            assert(card != drawnCard) { "Drawn card found in remaining deck" }
        }
    }

    @Test
    fun `deck can be cut`() {
        val cardDeck = CardDeck()
        val numberOfCards = 10
        val sizeOfRightCut = (expectedNumberOfCards - numberOfCards)

        val (left, right) = cardDeck.cut(numberOfCards)

        assert(numberOfCards == left.size())
        assert(sizeOfRightCut == right.size())
    }

    @Test
    fun `a cut deck can be rejoined`() {
        val cardDeck = CardDeck()
        val numberOfCards = 10

        val (left, right) = cardDeck.cut(numberOfCards)

        assert(cardDeck == (left.join(right)))

    }
}
