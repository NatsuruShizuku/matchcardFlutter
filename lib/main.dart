import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_application_0/managers/game_manager.dart';
// import 'package:flutter_application_0/models/word.dart';

import 'package:flutter_application_0/page/select_game.dart';

import 'package:flutter_application_0/theme/app_theme.dart';
// import 'package:provider/provider.dart';

// List<Word> sourceWords = [];

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => GameManager(hasImage: true, totalTiles: 6),
//       child: const MyApp(),
//     ),
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
//       home: const SelectGame(), // หรือ GamePage ที่ต้องการ
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: appTheme,
      home: const SelectGame(), // หน้าจอเลือกเกม
    );
  }
}
