//
//  ViewController.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dealerImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    
    var numberOfPlayers: Int!
    var participantHands = [Hand]()
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
        startPlayerTurn() // account for extra players
        playerTurn = false
        startDealerTurn()
    }
    
    func pregame(extraPlayers: Int, numberOfDecks: Int) {
        shoe = Shoe(numberOfDecks: numberOfDecks)!
        shoe.shuffle()
        shoe.burn()
        if extraPlayers > 0 {
            for _ in 1 ... extraPlayers {
                participantHands.append(Hand(playerID: PlayerID.others))
            }

        }
        participantHands.append(Hand(playerID: PlayerID.player))
        participantHands.append(Hand(playerID: PlayerID.house))
    }
    
    func deal() {
        for cardNum in 1 ... 2 {
            for hand in participantHands {
                if cardNum == 1 {
                    // the first card is linked to the one in the outlet
                    switch hand.playerID! {
                    case .house:
                        hand.addCard(card: shoe.draw(), vc: self)
                    case .player:
                        hand.addCard(card: shoe.draw(), vc: self)
                    case .others:
                        print("not implemented")
                        // get player based on tag
                    }
                } else {
                    hand.addCard(card: shoe.draw(), vc: self)
                }
            }
        }
    }
    
    func startPlayerTurn() {
        for hand in participantHands {
            // ensure that the player's turn is not over
            if hand.playerID == PlayerID.others {
                autoplay(hand: hand) // pass in hand and tag?
            }
            else if hand.playerID == PlayerID.player {
                play(hand: hand)
            }
            else {
                return
            }
        }
    }
    
    func play(hand: Hand) {
        var turnOver = false
        while (!turnOver) {
            if hand.getScore().min()! > 21 {
                turnOver = true
                break
            } else {
                let gesture = "stand"
//                let gesture = "hit"
                if gesture == "stand" {
                    turnOver = true
                    break
                }
                if gesture == "hit" {
                    hand.addCard(card: shoe.draw(), vc: self)
                    break
                }
            }
        }
    }
    
    func autoplay(hand: Hand) {
        
    }
    
    func startDealerTurn() {
        autoplay(hand: participantHands[participantHands.count - 1]) // dealer's hand is always the last one in the array
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

