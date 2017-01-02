//
//  Deck.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import Foundation
import GameplayKit

class Decks {
    
    var cards = [Card]()
    
    init?(numberOfDecks: Int = 1) {
        guard numberOfDecks >= 1 else {
            return nil
        }
        for _ in 1 ... numberOfDecks {
            for rank in Rank.allValues {
                for suit in Suit.allValues {
                    let card = Card.init(rank: rank, suit: suit)
                    cards.append(card)
                }
            }
        }
    }
    
    func shuffle() {
        self.cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
    
    func draw() -> Card {
        return cards.remove(at: 0)
    }
    
    func peek() -> Card {
        return cards[0]
    }
}
