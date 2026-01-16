import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'package:image_picker/image_picker.dart';

final List<Cards> dealerHand = [];
final List<Cards> playerHand = [];
final List<String> dealerImages = [];
final List<String> playerImages = [];
final List<String> cardSuits = ['c', 's', 'd', 'h'];
final List<dynamic> cardValue = [
  "a",
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  "j",
  "q",
  "k",
];

var incrementor = 0;
var dealerCardCount = 0;
var playerCardCount = 0;
var dealerAceCount = 0;
var playerAceCount = 0;
bool canhit = false;

// shuffle method comes from a stack overflow user.
// all it does is traverse the entire array and then pick an element at random
// to switch with that random element
List shuffle(List mycards) {
  var random = new Random();

  for (var i = mycards.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);

    var temp = mycards[i];
    mycards[i] = mycards[n];
    mycards[n] = temp;
  }

  return mycards;
}

class NewDeck {
  List<Cards> newDeck() {
    final List<Cards> deck = [];

    for (var i = 0; i < cardValue.length; i++) {
      for (var j = 0; j < 4; j++) {
        deck.add(Cards(cardValue[i].toString(), cardSuits[j].toString()));
      }
    }
    return deck;
  }
}

class Deck {
  List<Cards> cards;

  Deck([List<Cards>? cards]) : cards = cards ?? NewDeck().newDeck();

  @override
  String toString() => 'Deck(${cards.length} cards)';
}

class Cards {
  final String value;
  final String suit;

  Cards(this.value, this.suit);

  @override
  String toString() => "assets/cards/${value}${suit}.png";
}

class Dealer {
  final List<dynamic> dealerImgs = [];

  dealerImages() {
    if (dealerHand.isEmpty) {
      for (var i = 0; i <= dealerHand.length; i++) {
        dealerImgs[i] = dealerHand[i];
      }
    }
  }

  calculateSum() {
    var sum = 0;
    var numAces = 0;

    for (var card in dealerHand) {
      var cardval = card
          .value; // this works because both the dealerHand and playerHand are list instances of the Cards class
      // meaning they can directly access the values and suits of the cards

      if (cardval == "j" || cardval == "q" || cardval == "k") {
        sum = sum + 10;
      } else if (cardval == "a") {
        if (sum + 11 > 21) {
          sum = sum + 1;
        } else {
          sum = sum + 11;
        }
        numAces = numAces + 1;
        dealerAceCount = dealerAceCount + 1;
      } else {
        sum = sum + int.parse(cardval);
      }
    }

    while (sum > 21 && numAces > 0) {
      sum = sum - 11;
      numAces = numAces - 1;
      dealerAceCount = dealerAceCount - 1;
    }
    return sum;
  }
}

class Player {
  final List<dynamic> playerImgs = [];

  playerImages() {
    if (playerHand.isEmpty) {
      for (var i = 0; i <= playerHand.length; i++) {
        playerImgs[i] = playerHand[i];
      }
    }
  }

  calculateSum() {
    var sum = 0;
    var numAces = 0;

    for (var card in playerHand) {
      final cardval = card.value;

      if (cardval == "j" || cardval == "q" || cardval == "k") {
        sum = sum + 10;
      } else if (cardval == "a") {
        if (sum + 11 > 21) {
          sum = sum + 1;
        } else {
          sum = sum + 11;
        }
        numAces = numAces + 1;
        playerAceCount = playerAceCount + 1;
      } else {
        sum = sum + int.parse(cardval);
      }
    }

    while (sum > 21 && numAces > 0) {
      sum = sum - 10;
      numAces = numAces - 1;
      playerAceCount = playerAceCount - 1;
    }
    return sum;
  }
}

var deck = Deck();

var dealer = Dealer();
var player = Player();

class Restart {
  void restart() {
    incrementor = 0;
    dealerCardCount = 0;
    playerCardCount = 0;
    canhit = false;

    deck = new Deck();
    dealer = new Dealer();
    player = new Player();
    GameLogic().gameLogic();
  }
}

class DrawCard {
  // target is the playerHand or the dealerHand
  drawCard(var target) {
    var drawcard = deck.cards[incrementor];

    if (target == player) {
      playerHand.add(drawcard);
      playerImages.add(drawcard.toString());
    } else {
      dealerHand.add(drawcard);
      dealerImages.add(drawcard.toString());
    }
    incrementor++;
  }
}

class DealerDraw {
  dealerDraw() {
    var dealersum = dealer.calculateSum();

    if (dealersum == 21) {
      return;
    }

    while (dealersum < 17) {
      dealerCardCount = dealerCardCount + 1;

      var newCard = DrawCard().drawCard(dealer);

      dealersum = dealer.calculateSum();
    }
  }
}

class HitFunction {
  void hitFunction() {
    if (!canhit) {
      return;
    }

    playerCardCount = playerCardCount + 1;

    var newCard = DrawCard().drawCard(player);

    var playerSum = player.calculateSum();
    var dealerSum = dealer.calculateSum();

    if (playerSum > 21) {
      canhit = false;
      print("You busted dealer wins");
    }

    print("The dealersum is: ");
    print(dealerSum);
    print("The playersum is: ");
    print(playerSum);
  }
}

class Deal {
  deal() {
    dealer = new Dealer();
    player = new Player();

    canhit = true;
    dealerAceCount = 0;

    var playerCard1 = DrawCard().drawCard(player);
    var dealerCard1 = DrawCard().drawCard(dealer);
    var playerCard2 = DrawCard().drawCard(player);
    var dealerCard2 = DrawCard().drawCard(dealer);
    dealerCardCount = dealerCardCount + 2;
    playerCardCount = playerCardCount + 2;

    if (player.calculateSum() == 21) {
      // disable hit button. To be added
      canhit = false;
    }

    if (dealer.calculateSum() < 17) {
      DealerDraw().dealerDraw();
    }
  }
}

class Play {
  String play() {
    var dealerInitalCard = dealerHand[0];

    DealerDraw().dealerDraw();

    var dealerSum = dealer.calculateSum();
    var playerSum = player.calculateSum();

    String resultText = "";

    if (playerSum > 21) {
      resultText = "You Busted. Dealer Wins";
    } else if (dealerSum > 21) {
      resultText = "Dealer Busted. You Win";
    } else if (playerSum == 21 && playerCardCount == 2) {
      if (dealerSum != 21) {
        resultText = "BlackJack You Win";
      } else {
        resultText = "Its a Tie";
      }
    } else if (dealerSum == 21 && dealerCardCount == 2) {
      if (playerSum != 21) {
        resultText = "BlackJack Dealer Wins";
      } else {
        resultText = "Its a Tie";
      }
    } else if (dealerSum > playerSum) {
      resultText = "Dealer Wins";
    } else if (playerSum > dealerSum) {
      resultText = "You Win";
    } else {
      resultText = "Its a Tie";
    }

    print(resultText);
    return resultText;
  }
}

class GameLogic {
  void gameLogic() {
    incrementor = 0;
    dealerAceCount = 0;
    playerCardCount = 0;
    dealerCardCount = 0;
    dealerHand.clear();
    playerHand.clear();
    dealerImages.clear();
    playerImages.clear();
    canhit = false;

    NewDeck().newDeck();

    for (var i = 0; i < 3; i++) {
      shuffle(deck.cards);
    }

    Deal().deal();

    print("The dealers hand");
    print(dealerImages);

    print("The players hand");
    print(playerImages);

    print("The dealer sum is");
    print(dealer.calculateSum());

    print("The playersum is");
    print(player.calculateSum());
  }
}
