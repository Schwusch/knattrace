import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Challenge {
  static final String baseAddress = "https://etuu2mjcx3.execute-api.eu-west-1.amazonaws.com/v1";

  String description;
  List<Clue> clues;
  int gridColumns;

  Challenge.fromMap(Map<String, dynamic> map)
      : description = map["description"],
        clues = new List<Clue>.from(map["clues"].map((clue) => new Clue.fromMap(clue))),
        gridColumns = map["columns"];

  Challenge();

  static Future<Challenge> retrieve(String challengeId, String name, String password) async {
    if(challengeId == null) return null;

    String problem = await http.read("$baseAddress/challenge/$challengeId/$name/$password", headers: {"Content-Type": "application/json"});
    Challenge challenge;
    try {
      challenge = new Challenge.fromMap(json.decode(problem));
    } catch (exception, stackTrace) {
      print(exception);
      print(stackTrace);
    }
    return challenge;
  }

  Challenge clone() {
    Challenge copy = new Challenge();
    copy.description = this.description;
    copy.gridColumns = this.gridColumns;
    copy.clues = this.clues.map((clue) =>
      new Clue(new Uint8List.fromList(clue.image), clue.key)
    ).toList(growable: false);

    return copy;
  }
}

class Clue {
  List<int> image;
  String key;

  Clue(this.image, this.key);

  Clue.fromMap(Map<String, dynamic> map)
      : image = base64.decode(map["image"]),
        key = map["key"];
}

class SolvableChallenge {
  Challenge challenge;
  String id;
  SolvableChallenge(this.challenge, this.id);
}
