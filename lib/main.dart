
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';

import 'package:flutter_application_0/page/select_game.dart';

import 'package:flutter_application_0/theme/app_theme.dart';
import 'package:provider/provider.dart';



List<Word> sourceWords = [];

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // await Firebase.initializeApp();

//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

//   runApp(
//          const MyApp(),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Memory Game',
//       theme: appTheme,
//       home: Material(
//           child: ChangeNotifierProvider(
//               create: (_) => GameManager(), child: const GameLevel())),
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameManager(hasImage: true),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: appTheme,
      home: const SelectGame(), // หรือ GamePage ที่ต้องการ
    );
  }
}


// Future<int> populateSourceWords() async {
//   // final ref = FirebaseStorage.instance.ref();
//   // final all = await ref.listAll();

//   for (var item in all.items) {
//     sourceWords.add(Word(
//         // text: item.name.substring(0, item.name.indexOf('.')),
//         // url: await item.getDownloadURL(),
//         displayText: false, 
//         id: 0, descrip: '', contents: [], matraID: 1));
//   }

//   return 1;
// }