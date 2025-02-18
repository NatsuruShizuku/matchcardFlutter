import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/animation/flip_animation.dart';
import 'package:flutter_application_0/animation/matched_animation.dart';
import 'package:flutter_application_0/animation/spin_animation.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:provider/provider.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    required this.index,
    required this.word,
    Key? key,
    required this.hasImage,
  }) : super(key: key);

  final int index;
  final Word word;
  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    return SpinAnimation(
      child: Consumer<GameManager>(
        builder: (_, notifier, __) {
          bool animate = checkAnimationRun(notifier);

          // return GestureDetector(
          //   onTap: () {
          //     if (!notifier.ignoreTaps &&
          //         !notifier.answeredWords.contains(index) &&
          //         !notifier.tappedWords.containsKey(index)) {
          //       notifier.tileTapped(index: index, word: word);
          //     }
          //   },
          // //   child: FlipAnimation(
          // //     delay: notifier.reverseFlip ? 1500 : 0,
          // //     reverse: notifier.reverseFlip,
          // //     animationCompleted: (isForward) {
          // //       notifier.onAnimationCompleted(isForward: isForward);
          // //     },
          // //     animate: animate,
          // //     word: MatchedAnimation(
          // //       numberOfWordsAnswered: notifier.answeredWords.length,
          // //       animate: notifier.answeredWords.contains(index),
          // //       child: Container(
          // //           padding: const EdgeInsets.all(16),
          // //           child: word.displayText
          // //               ? FittedBox(
          // //                   fit: BoxFit.scaleDown,
          // //                   child: Transform(
          // //                       alignment: Alignment.center,
          // //                       transform: Matrix4.rotationY(pi),
          // //                       child: Text(word.descrip)))
          // //               : _buildImage(word.contents)
          // //     ),
          // //   ),
          // // )
return GestureDetector(
  onTap: () {
    if (!notifier.ignoreTaps &&
        !notifier.answeredWords.contains(index) &&
        !notifier.tappedWords.containsKey(index)) {
      notifier.tileTapped(index: index, word: word);
    }
  },
  child: FlipAnimation(
    word: MatchedAnimation(
      numberOfWordsAnswered: notifier.answeredWords.length,
      animate: notifier.answeredWords.contains(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: word.displayText || !hasImage
            ? _buildText()
            : _buildImage(),
      ),
    ),
    animate: checkAnimationRun(notifier),
    reverse: notifier.reverseFlip,
    animationCompleted: (isForward) {
      notifier.onAnimationCompleted(isForward: isForward);
    },
  ),
);
          
        },
      ),
    );
  }

  Widget _buildText() {
    return FittedBox(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Text(word.descrip),
      ),
    );
  }

  // Widget _buildImage() {
  //   return Image.memory(
  //     Uint8List.fromList(word.contents),
  //     fit: BoxFit.contain,
  //   );
  // }
  Widget _buildImage() {
  try {
    return Image.memory(
      Uint8List.fromList(word.contents), // ตรวจสอบว่า word.contents ไม่ว่างเปล่า
      fit: BoxFit.contain,
    );
  } catch (e) {
    print('เกิดข้อผิดพลาดในการโหลดรูปภาพ: $e');
    return const Icon(Icons.error); // แสดงไอคอนข้อผิดพลาดหากโหลดรูปภาพไม่สำเร็จ
  }
}

  bool checkAnimationRun(GameManager notifier) {
    bool animate = false;

    if (notifier.canFlip) {
      if (notifier.tappedWords.isNotEmpty &&
          notifier.tappedWords.keys.last == index) {
        animate = true;
      }
      if (notifier.reverseFlip && !notifier.answeredWords.contains(index)) {
        animate = true;
      }
    }
    return animate;
  }
}

// }
