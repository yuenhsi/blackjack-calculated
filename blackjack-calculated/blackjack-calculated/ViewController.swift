//
//  ViewController.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import UIKit

enum PlayerID {
    case house, player, others
}

struct Hand {
    var playerID: PlayerID!
    var cards: [Card]!
    var cardImage: [UIImageView]!
    
    mutating func addCard(card: Card, image: UIImageView) {
        cards.append(card)
        cardImage.append(image)
    }
    
    mutating func addCard(card: Card) {
        cards.append(card)
        switch playerID! {
        case .house:
            let prevImage = cardImage[cardImage.count - 1]
            let thisImage = UIImageView()
            thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y, width: 80, height: 110)
            cardImage.append(thisImage)
        case .player:
            let prevImage = cardImage[cardImage.count - 1]
            let thisImage = UIImageView()
            thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y - 20, width: 80, height: 110)
            cardImage.append(thisImage)
        case .others:
            let prevImage = cardImage[cardImage.count - 1]
            let thisImage = UIImageView()
            thisImage.frame = CGRect(x: prevImage.frame.origin.x + 20, y: prevImage.frame.origin.y - 20, width: 40, height: 55)
            cardImage.append(thisImage)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var dealerImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    
    var numberOfPlayers: Int!
    var participantHands = [Hand]() {
        didSet {
            updateBoard()
        }
    }
    var shoe: Shoe!
    var playerTurn: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame(extraPlayers: 0)
    }
    
    func startGame(extraPlayers: Int) {
        numberOfPlayers = extraPlayers + 1
        playerTurn = true
        pregame(extraPlayers: extraPlayers, numberOfDecks: 3)
        deal()
    }
    
    func pregame(extraPlayers: Int, numberOfDecks: Int) {
        shoe = Shoe(numberOfDecks: numberOfDecks)!
        shoe.shuffle()
        shoe.burn()
        if extraPlayers > 0 {
            for _ in 1 ... extraPlayers {
                participantHands.append(Hand(playerID: PlayerID.others, cards: [], cardImage: []))
            }

        }
        participantHands.append(Hand(playerID: PlayerID.player, cards: [], cardImage: []))
        participantHands.append(Hand(playerID: PlayerID.house, cards: [], cardImage: []))
    }
    
    func deal() {
        for cardNum in 1 ... 2 {
            for index in participantHands.indices {
                if cardNum == 1 {
                    // the first card is linked to the one in the outlet
                    switch participantHands[index].playerID! {
                    case .house:
                        participantHands[index].addCard(card: shoe.draw(), image: dealerImageView)
                    case .player:
                        participantHands[index].addCard(card: shoe.draw(), image: playerImageView)
                    case .others:
                        print("not implemented")
                        // get player based on tag
                    }
                } else {
                    participantHands[index].addCard(card: shoe.draw())
                }
            }
        }
    }
    
    func updateBoard() {
        print("board updating")
        // populate imageViews
        for hand in participantHands {
            for (index, card) in hand.cards.enumerated() {
                var cardName = ""
                if (playerTurn && index == 0 && hand.playerID == PlayerID.house) {
                    cardName = getFaceDownCardName()
                } else {
                    cardName = getCardName(card: card)
                }
                if hand.cardImage[index].image == nil {
                    hand.cardImage[index].image = UIImage(named: cardName)
                    view.addSubview(hand.cardImage[index])
                }
            }
        }
    }
    
    func getFaceDownCardName() -> String {
        return "cardBack_blue3.png"
    }
    
    func getCardName(card: Card) -> String {
        return "card\(card.Suit.rawValue)\(card.Rank.rawValue).png"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

