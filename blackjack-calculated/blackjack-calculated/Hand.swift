//
//  Hand.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/3/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import Foundation
import UIKit

enum PlayerID {
    case house, player, others
}

class Hand {
    var playerID: PlayerID!
    var cards: [Card]!
    var cardImage: [UIImageView]!
    
    init(playerID: PlayerID) {
        self.playerID = playerID
        self.cards = []
        self.cardImage = []
    }
    
    func addCard(card: Card, image: UIImageView, vc: ViewController) {
        cards.append(card)
        cardImage.append(image)
    }
    
    func addCard(card: Card, vc: ViewController) {
        cards.append(card)
        switch playerID! {
        case .house:
            if cardImage.count == 0 {
                cardImage.append(vc.dealerImageView)
            } else {
                let prevImage = cardImage[cardImage.count - 1]
                let thisImage = UIImageView()
                thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y, width: 80, height: 110)
                cardImage.append(thisImage)
            }
        case .player:
            if cardImage.count == 0 {
                cardImage.append(vc.playerImageView)
            } else {
                let prevImage = cardImage[cardImage.count - 1]
                let thisImage = UIImageView()
                thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y - 20, width: 80, height: 110)
                cardImage.append(thisImage)
            }
        case .others:
            // get tag and assign imageVIew
            let prevImage = cardImage[cardImage.count - 1]
            let thisImage = UIImageView()
            thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y - 20, width: 40, height: 55)
            cardImage.append(thisImage)
        }
        vc.updateBoard()
    }
    
    func getScore() -> [Int] {
        var scores = [0]
        for card in cards {
            let cardScore = card.getScore()
            if cardScore != -1 {
                for index in 0 ..< scores.count {
                    scores[index] += cardScore
                }
            } else {
                var newScores = [Int]()
                for score in scores {
                    newScores.append(score + 1)
                    newScores.append(score + 11)
                }
                scores = newScores
            }
        }
        return scores
    }
}
