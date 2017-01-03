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
    var cardImage: UIImageView!
    
    mutating func addCard(card: Card) {
        cards.append(card)
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
        updateBoard()
    }
    
    func pregame(extraPlayers: Int, numberOfDecks: Int) {
        shoe = Shoe(numberOfDecks: numberOfDecks)!
        shoe.shuffle()
        shoe.burn()
        if extraPlayers > 0 {
            for _ in 1 ... extraPlayers {
                participantHands.append(Hand(playerID: PlayerID.others, cards: []))
            }

        }
        participantHands.append(Hand(playerID: PlayerID.player, cards: []))
        participantHands.append(Hand(playerID: PlayerID.house, cards: []))
        
        for _ in 1 ... 2 {
            for index in participantHands.indices {
                participantHands[index].addCard(card: shoe.draw())
            }
        }
    }
    
    func updateBoard() {
        print("board updated")
        // populate imageViews depending on cards
        var cardImageView = UIImageView()
        for hand in participantHands {
            switch hand.playerID! {
            case .house:
                cardImageView = dealerImageView
            case .player:
                cardImageView = playerImageView
            case .others:
                print("not implemented")
                // get player based on tag
            }
            for card in hand.cards {
                let cardName = getCardName(card: card)
                if cardImageView.image == nil {
                    print("here")
                    cardImageView.image = UIImage(named: cardName)
                } else {
                    
                }
            }
        }
    }
    
    func getCardName(card: Card) -> String {
        return "card\(card.Suit.rawValue)\(card.Rank.rawValue).png"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

