import 'package:flutter/material.dart';

class Keywords {
  static Map<RegExp, TextStyle> keywords = {
    RegExp(
      "joy|excited|optimistic|proud|cheerful|happy|content|peaceful/g",
    ): TextStyle(
      color: Colors.lightGreen,
      fontSize: 16.0,
    ),
    RegExp(
      "love|grateful|sentimental|affectionate|enchanted|nostalgic/g",
    ): TextStyle(
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.bold,
    ),
    RegExp(
      "anger|enraged|exasperated|irritable|jealous|disgusted/g",
    ): TextStyle(
      color: Colors.redAccent,
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dashed,
    ),
    RegExp(
      "sad|hurt|unhappy|disappointed|shameful|lonely|gloomy/g",
    ): TextStyle(
      fontSize: 13.0,
      color: Colors.purpleAccent,
      fontStyle: FontStyle.italic,
    ),
    RegExp(
      "surprise|moved|overcome|amazed|consfused|stunned/g",
    ): TextStyle(
      fontSize: 14.0,
      color: Colors.grey,
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.wavy,
    ),
  };

  static Map<RegExp, TextStyle> getKeywords() {
    return keywords;
  }
}
