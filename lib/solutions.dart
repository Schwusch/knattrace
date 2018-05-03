import 'Challenge.dart';
import 'package:image/image.dart';

Challenge solveChallenge(Challenge original, String id) {
  if (original == null || id == null) return null;

  Challenge solved = original;

  switch(id) {
    case "start":
//      solved = firstSolver(original.clone());
      break;
  }
  return solved;
}

/// Solves first challenge, which is sorting
Challenge firstSolver(Challenge challenge) {
  challenge.clues.sort((a, b) => int.parse(a.key) - int.parse(b.key));
  return challenge;
}