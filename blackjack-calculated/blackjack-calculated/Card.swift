//
//  Card.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import Foundation

enum Rank: String {
    case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10", jack = "J", queen = "Q", king = "K", ace = "A"
    static let allValues = [two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace]
}

enum Suit: String {
    case diamonds = "Diamonds", clubs = "Clubs", hearts = "Hearts", spades = "Spades"
    static let allValues = [diamonds, clubs, hearts, spades]
}

struct Card {
    var Rank: Rank
    var Suit: Suit
    
    init(rank: Rank, suit: Suit) {
        self.Rank = rank
        self.Suit = suit
    }
}
