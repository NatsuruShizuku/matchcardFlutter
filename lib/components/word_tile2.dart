// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/managers/game_manager.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class WordTile extends StatelessWidget {
//   final int index;
//   final Word word;
//   final bool hasImage;
//   final bool isMatched;

//   const WordTile({
//     required this.index,
//     required this.word,
//     required this.hasImage,
//     required this.isMatched,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         final gameManager = Provider.of<GameManager>(context, listen: false);
//         if (!gameManager.ignoreTaps &&
//             !gameManager.answeredWords.contains(index) &&
//             !gameManager.tappedWords.containsKey(index)) {
//           gameManager.tileTapped(index: index, word: word);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: isMatched ? Colors.green[100] : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Center(
//           child: word.displayText || !hasImage
//               ? _buildText()
//               : _buildImage(),
//         ),
//       ),
//     );
//   }

//   Widget _buildText() {
//     return Text(
//       word.descrip,
//       style: GoogleFonts.chakraPetch(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.blue[800],
//       ),
//     );
//   }

//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Image.memory(
//         Uint8List.fromList(word.contents),
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//    bool checkAnimationRun(GameManager notifier) {
//     bool animate = false;

//     if (notifier.canFlip) {
//       if (notifier.tappedWords.isNotEmpty &&
//           notifier.tappedWords.keys.last == index) {
//         animate = true;
//       }
//       if (notifier.reverseFlip && !notifier.answeredWords.contains(index)) {
//         animate = true;
//       }
//     }
//     return animate;
//   }
// }