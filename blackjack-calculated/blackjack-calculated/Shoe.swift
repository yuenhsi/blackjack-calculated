//
//  Shoe.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import Foundation
import GameplayKit

struct Shoe {
    
    var cards = [Card]()
    
    init?(numberOfDecks: Int = 1) {
        guard numberOfDecks >= 1 else {
            return nil
        }
        for _ in 1 ... numberOfDecks {
            addDeck()
        }
    }
    
    mutating func addDeck() {
        for rank in Rank.allValues {
            for suit in Suit.allValues {
                let card = Card.init(rank: rank, suit: suit)
                cards.append(card)
            }
        }
    }
    
    mutating func shuffle() {
        self.cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
    
    mutating func draw() -> Card {
        return cards.remove(at: 0)
    }
    
    mutating func burn() {
        cards.remove(at: 0)
    }
    
    func peek() -> Card {
        return cards[0]
    }
}
