import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/animation/flip_animation.dart';
import 'package:flutter_application_0/animation/matched_animation.dart';
import 'package:flutter_application_0/animation/spin_animation.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    required this.index,
    required this.word,
    Key? key,
    required this.hasImage,
    required this.isMatched,
  }) : super(key: key);

  final int index;
  final Word word;
  final bool hasImage;
  final bool isMatched;

  @override
  Widget build(BuildContext context) {
    debugPrint('WordTile at index $index rebuilt');
    return SpinAnimation(
      key: ValueKey<int>(index), // เพิ่ม Key เพื่อแยกแยะ Widget แต่ละตัว
      child: Consumer<GameManager>(
        builder: (_, notifier, __) {
          if (isMatched) {
            // หากการ์ดจับคู่ถูกต้อง ให้แสดงผลแบบคงที่
            return Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          }

          bool animate = checkAnimationRun(notifier);

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
                  // child: word.displayText || !hasImage
                  // ? _buildText()
                  // : _buildImage(),
                  child: _buildImage(),
                ),
              ),
              // animate: checkAnimationRun(notifier),
              animate: animate,
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

  // Widget _buildText() {
  //   return FittedBox(
  //     child: Transform(
  //       alignment: Alignment.center,
  //       transform: Matrix4.rotationY(pi),
  //       child: Text(word.descrip),
  //     ),
  //   );
  // }
//   Widget _buildText() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Center(
//       child: Text(
//         word.descrip,
//         style: GoogleFonts.chakraPetch(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.deepPurple,
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildImage() {
//   try {
//     return Image.memory(
//       Uint8List.fromList(word.contents), // ตรวจสอบว่า word.contents ไม่ว่างเปล่า
//       fit: BoxFit.contain,
//     );
//   } catch (e) {
//     print('เกิดข้อผิดพลาดในการโหลดรูปภาพ: $e');
//     return const Icon(Icons.error); // แสดงไอคอนข้อผิดพลาดหากโหลดรูปภาพไม่สำเร็จ
//   }
// }
  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Image.memory(
          Uint8List.fromList(word.contents),
          fit: BoxFit.cover,
        ),
      ),
    );
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
