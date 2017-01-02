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
    
    mutating func addCard(card: Card) {
        cards.append(card)
    }
}

class ViewController: UIViewController {
    
    var numberOfPlayers: Int!
    var participantHands = [Hand]() {
        didSet {
            updateBoard()
        }
    }
    var shoe: Shoe!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame(extraPlayers: 0)
    }
    
    func startGame(extraPlayers: Int) {
        numberOfPlayers = extraPlayers + 1
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
        // add imageViews based on numberOfPlayers, if they don't exist yet
            // let all cards height be 1/4 the width of device (as this game only allows landscape)
            // card offset = 1/4 card width
            // dealer: center horizontal - 1.5 * offset, 2/5 device height from top
            // player: center horizontal, 1/5 device height from bottom
        
        // populate imageViews depending on cards
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

