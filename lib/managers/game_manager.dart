import 'package:flutter/material.dart';
import 'package:flutter_application_0/managers/audio_manager.dart';
import 'package:flutter_application_0/models/word.dart';


class GameManager extends ChangeNotifier {
  Map<int, Word> tappedWords = {};
  bool canFlip = false,
      reverseFlip = false,
      ignoreTaps = false,
      roundCompleted = false;
  List<int> answeredWords = [];
  bool hasImage;
  final int totalTiles;
    GameManager( {required this.hasImage,required this.totalTiles}); // กำหนดค่าเริ่มต้น


  // tileTapped({required int index, required Word word}) {
  //   ignoreTaps = true;
  //   if (tappedWords.length <= 1) {
  //     tappedWords.addEntries([MapEntry(index, word)]);
  //     canFlip = true;
  //   } else {
  //     canFlip = false;
  //   }

  //   notifyListeners();
  // }
  tileTapped({required int index, required Word word}) {
  ignoreTaps = true;
  if (tappedWords.length <= 1) {
    tappedWords.addEntries([MapEntry(index, word)]);
    canFlip = true;
  } else {
    canFlip = false;
  }
  notifyListeners();
}

onAnimationCompleted({required bool isForward}) async {
  if (tappedWords.length == 2) {
    if (isForward) {
      bool isMatch;
      if (hasImage) {
        isMatch = tappedWords.entries.elementAt(0).value.matraID ==
            tappedWords.entries.elementAt(1).value.matraID;
      } else {
        isMatch = tappedWords.entries.elementAt(0).value.descrip ==
            tappedWords.entries.elementAt(1).value.descrip;
      }

      if (isMatch) {
        answeredWords.addAll(tappedWords.keys);
        if (answeredWords.length == totalTiles) {
          await AudioManager.playAudio('Round');
          roundCompleted = true;
        } else {
          await AudioManager.playAudio('Correct');
        }
        tappedWords.clear();
        canFlip = true;
        ignoreTaps = false;
      } else {
        await AudioManager.playAudio('Incorrect');
        reverseFlip = true;
      }
    } else {
      reverseFlip = false;
      tappedWords.clear();
      ignoreTaps = false;
    }
  } else {
    canFlip = false;
    ignoreTaps = false;
  }
  notifyListeners();
}
}


