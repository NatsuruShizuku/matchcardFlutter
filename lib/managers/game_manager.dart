import 'dart:async';

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
  int moves = 0;
  int secondsElapsed = 0;
  late Timer _timer;
  
    GameManager( {required this.hasImage,required this.totalTiles}){
    _startTimer(); // เริ่มจับเวลาทันทีเมื่อสร้าง GameManager
  }

 void _startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    secondsElapsed++;
    // เรียก notifyListeners() เฉพาะเมื่อจำเป็น
    if (secondsElapsed % 1 == 0) { 
      notifyListeners();
    }
  });
}

 void stopTimer() {
    _timer.cancel();
  }

  tileTapped({required int index, required Word word}) {
    moves++;
  ignoreTaps = true;
  if (tappedWords.length <= 1) {
    tappedWords.addEntries([MapEntry(index, word)]);
    canFlip = true;
  } else {
    canFlip = false;
  }
  notifyListeners();
}

@override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

onAnimationCompleted({required bool isForward}) async {
  if (tappedWords.length == 2) {
    if (isForward) {
      bool isMatch;

        isMatch = tappedWords.entries.elementAt(0).value.matraID ==
            tappedWords.entries.elementAt(1).value.matraID;
      

      if (isMatch) {
        answeredWords.addAll(tappedWords.keys);
        if (answeredWords.length == totalTiles) {
          await AudioManager().playAudio('Round');
          roundCompleted = true;
        } else {
          await AudioManager().playAudio('Correct');
        }

        tappedWords.clear();
        canFlip = true;
        ignoreTaps = false;
      } else {
        await AudioManager().playAudio('Incorrect');
        reverseFlip = true;
      }
    } else {
      reverseFlip = false;
      tappedWords.clear();
      canFlip = true;
      ignoreTaps = false;
    }
  } else {
    canFlip = false;
    ignoreTaps = false;
  }
  notifyListeners();
}
}


