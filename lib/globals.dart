import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "dart:io";

import "package:flutter_application_1/game_logic.dart";

class Globals {
  static final Globals _instance = Globals._internal();

  factory Globals() => _instance;

  Globals._internal();

  List<Cards> cardDeck = [];
}
