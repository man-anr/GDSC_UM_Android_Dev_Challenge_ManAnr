import 'dart:math';

class Evaluator {
  static int MAXQUOTELIST = 5;
  static Map<int, Map<String, String>> negQuotes = {
    1: {
      "author": "Abraham Lincoln",
      "text": "A house divided against itself cannot stand."
    },
    2: {
      "author": "Abraham Lincoln",
      "text": "Important principles may, and must, be inflexible."
    },
    3: {
      "author": "Abraham Lincoln",
      "text": "I destroy my enemies when I make them my friends."
    },
    4: {
      "author": "Abraham Lincoln",
      "text":
          "You have to do your own growing no matter how tall your grandfather was."
    },
    5: {
      "author": "Abraham Lincoln",
      "text": "Most people are about as happy as they make up their minds to be"
    }
  };

  static Map<int, Map<String, String>> neuQuotes = {
    1: {
      "author": "Abraham Lincoln",
      "text":
          "Give me six hours to chop down a tree and I will spend the first four sharpening the axe."
    },
    2: {
      "author": "Abraham Lincoln",
      "text":
          "When you have got an elephant by the hind legs and he is trying to run away, it's best to let him run."
    },
    3: {
      "author": "Abraham Lincoln",
      "text":
          "The best thing about the future is that it only comes one day at a time."
    },
    4: {
      "author": "Abraham Lincoln",
      "text":
          "Character is like a tree and reputation like a shadow. The shadow is what we think of it; the tree is the real thing."
    },
    5: {
      "author": "Abraham Lincoln",
      "text": "As our case is new, we must think and act anew."
    },
  };
  static Map<int, Map<String, String>> posQuotes = {
    1: {
      "author": "Abraham Lincoln",
      "text": "Be sure you put your feet in the right place, then stand firm."
    },
    2: {
      "author": "Abraham Lincoln",
      "text":
          "Always bear in mind that your own resolution to succeed is more important than any one thing."
    },
    3: {
      "author": "Abraham Lincoln",
      "text": "I walk slowly, but I never walk backward."
    },
    4: {
      "author": "Abraham Lincoln",
      "text": "Truth is generally the best vindication against slander."
    },
    5: {
      "author": "Abraham Lincoln",
      "text": "Most folks are as happy as they make up their minds to be."
    },
  };
  static String? getResult(double pos, double neg) {
    double neutrality = (pos - neg).abs();
    double threshold = 0.10792599201202393;
    return (pos > neg)
        ? 'pos'
        : (neutrality <= threshold)
            ? 'neu'
            : 'neg';
  }

  static Map<String, String>? getQuotes(String? result) {
    int rad = new Random().nextInt(MAXQUOTELIST);

    switch (result) {
      case 'pos':
        return posQuotes[rad];
        break;
      case 'neg':
        return negQuotes[rad];
        break;
      case 'neu':
        return neuQuotes[rad];
        break;
    }

    print(rad);
  }
}
