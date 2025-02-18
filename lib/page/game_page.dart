import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/animation/confetti_animation.dart';
import 'package:flutter_application_0/components/replay_popup.dart';
import 'package:flutter_application_0/components/word_tile.dart';
import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/main.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:provider/provider.dart';
import 'error_page.dart';
import 'loading_page.dart';

class GamePage extends StatefulWidget {
  final int rows;
  final int columns;
  final bool hasImage; // รับค่าโหมดเกม

  const GamePage({super.key, required this.rows, required this.columns, required this.hasImage});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Future<int>? _futureCachedImages;
  Future<int>? _futureCachedImages;
  List<Word> _gridWords = [];
  late final DatabaseHelper _dbHelper;
  List<Word> sourceWords = [];

   late final GameManager _gameManager;

  @override
  void initState() {
    super.initState();
     _gameManager = GameManager(hasImage: widget.hasImage);
    _dbHelper = DatabaseHelper.instance;
    // 1. โหลดข้อมูลจากฐานข้อมูลก่อน
    _loadWordsFromDB().then((_) {
      // 2. เมื่อโหลดข้อมูลเสร็จ ให้ตั้งค่าและแคชรูปภาพ
      _setUp();
      if (widget.hasImage) {
        _futureCachedImages = _cacheImages();
      } else {
        // ถ้าเป็นโหมดจับคู่คำศัพท์ ให้กำหนด Future ให้เสร็จทันที
        _futureCachedImages = Future.value(1);
      }
      // _futureCachedImages = _cacheImages(); // กำหนดค่าให้ _futureCachedImages
    });
  }

  // _loadWordsFromDB() async {
  //   try {
  //     List<Map<String, dynamic>> maps = await _dbHelper.queryAllWords();
  //     if (maps.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('ไม่มีข้อมูลในฐานข้อมูล')),
  //       );
  //       return;
  //     }
  //     sourceWords = maps.map((map) => Word.fromMap(map)).toList();
  //     setState(() {});
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
  //     );
  //     // sourceWords = []; // กำหนดค่าเริ่มต้นหากโหลดไม่สำเร็จ
  //   }
  // }
  _loadWordsFromDB() async {
  try {
    List<Map<String, dynamic>> maps = await _dbHelper.queryAllWords();
    if (maps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่พบข้อมูลในฐานข้อมูล')),
      );
      return;
    }
    sourceWords = maps.map((map) {
      final contents = map['contents'] as List<int>? ?? [];
      if (contents.isEmpty) {
        print('คำเตือน: รูปภาพสำหรับคำศัพท์ ${map['descrip']} ไม่มีข้อมูล');
      }
      return Word.fromMap(map);
    }).toList();
    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
    );
  }
}

  // _setUp() {
  //   if (sourceWords.isEmpty) {
  //     print('ไม่มีข้อมูลในฐานข้อมูล');
  //     return;
  //   }

  //   sourceWords.shuffle();
  //   for (int i = 0; i < 3; i++) {
  //     _gridWords.add(sourceWords[i]);
  //     _gridWords.add(Word(
  //       id: sourceWords[i].id,
  //       descrip: sourceWords[i].descrip,
  //       contents: sourceWords[i].contents,
  //       matraID: sourceWords[i].matraID,
  //       displayText: true,
  //     ));
  //   }
  //   _gridWords.shuffle();
  _setUp() {
    if (sourceWords.isEmpty) return;

    final totalPairs = (widget.rows * widget.columns) ~/ 2;
    sourceWords.shuffle();

    if (sourceWords.length < totalPairs) {
      throw Exception('ไม่พบคำศัพท์เพียงพอในฐานข้อมูล');
    }

    for (int i = 0; i < totalPairs; i++) {
      // _gridWords.add(sourceWords[i]);
      final originalWord = sourceWords[i];
      _gridWords.add(originalWord);
      // if (widget.hasImage) {

      // _gridWords.add(
      //   Word(
      //       id: sourceWords[i].id,
      //       descrip: sourceWords[i].descrip,
      //       contents: sourceWords[i].contents,
      //       matraID: sourceWords[i].matraID,
      //       displayText: true),
      // );
      // } else {
      //   // โหมดคำศัพท์: เพิ่มคำศัพท์คู่
      //   _gridWords.add(
      //     Word(
      //       id: sourceWords[i].id,
      //       descrip: sourceWords[i].descrip,
      //       contents: [], // ไม่ใช้รูปภาพ
      //       matraID: sourceWords[i].matraID,
      //       displayText: true,
      //     ),
      //   );
      // }
      _gridWords.add(
      Word(
        id: originalWord.id,
        descrip: originalWord.descrip,
        contents: [],
        matraID: originalWord.matraID,
        displayText: true,
      ),
    );
    }
    _gridWords.shuffle();
  }

  Widget _buildImage(List<int> bytes) {
    return Image.memory(
      Uint8List.fromList(bytes),
      fit: BoxFit.contain,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   final widthPadding = size.width * 0.10;
  //   return FutureBuilder(
  //     future: _futureCachedImages,
  //     builder: (context, snapshot) {
  //       if (_futureCachedImages == null) {
  //         // ตรวจสอบว่า Future ถูกกำหนดค่าหรือไม่
  //         return const LoadingPage();
  //       }
  //       if (snapshot.hasError) {
  //         return const ErrorPage();
  //       }
  //       if (snapshot.hasData) {
  //         return Selector<GameManager, bool>(
  //           selector: (_, gameManager) => gameManager.roundCompleted,
  //           builder: (_, roundCompleted, __) {
  //             WidgetsBinding.instance.addPostFrameCallback(
  //               (timeStamp) async {
  //                 if (roundCompleted) {
  //                   await showDialog(
  //                       barrierColor: Colors.transparent,
  //                       barrierDismissible: false,
  //                       context: context,
  //                       builder: (context) => const ReplayPopUp());
  //                 }
  //               },
  //             );

  //             return Stack(
  //               children: [
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                       image: DecorationImage(
  //                           fit: BoxFit.fill,
  //                           image: AssetImage('assets/images/Cloud.png'))),
  //                 ),
  //                 SafeArea(
  //                   child: Center(
  //                     child: GridView.builder(
  //                         shrinkWrap: true,
  //                         padding: EdgeInsets.only(
  //                             left: widthPadding, right: widthPadding),
  //                         itemCount: 6,
  //                         gridDelegate:
  //                             SliverGridDelegateWithFixedCrossAxisCount(
  //                                 crossAxisCount: 3,
  //                                 crossAxisSpacing: 10,
  //                                 mainAxisSpacing: 10,
  //                                 mainAxisExtent: size.height * 0.38),
  //                         itemBuilder: (context, index) => WordTile(
  //                               index: index,
  //                               word: _gridWords[index],
  //                             )),
  //                   ),
  //                 ),
  //                 ConfettiAnimation(animate: roundCompleted)
  //               ],
  //             );
  //           },
  //         );
  //       } else {
  //         return const LoadingPage();
  //       }
  //     },
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   return ChangeNotifierProvider(
  //     create: (_) => _gameManager,
  //   child:  Scaffold(
  //     body: FutureBuilder(
  //       future: _futureCachedImages,
  //       builder: (context, snapshot) {
  //         if (_futureCachedImages == null) {
  //           return const LoadingPage(); // แสดง LoadingPage หาก Future ยังไม่ถูกกำหนดค่า
  //         }
  //         if (snapshot.hasError) return const ErrorPage();
  //         // if (snapshot.connectionState != ConnectionState.done) {
  //         if (!widget.hasImage || snapshot.connectionState == ConnectionState.done) {
  //           // return const LoadingPage();
  //           return _buildGameGrid();
  //         }
  //      return const LoadingPage();
  //      },
  //     ),
  //   ),
  //   );
  // }
@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: _futureCachedImages,
    builder: (context, snapshot) {
      if (snapshot.hasError) return const ErrorPage();

      // ถ้าเป็นโหมดคำศัพท์ หรือโหลดภาพเสร็จแล้ว
      final isDataReady = !widget.hasImage || snapshot.connectionState == ConnectionState.done;

      if (isDataReady) {
        return _buildGameGrid();
      }

      return const LoadingPage();
    },
  );
}

  Widget _buildGameGrid() {
    final size = MediaQuery.of(context).size;
    return Selector<GameManager, bool>(
      selector: (_, gameManager) => gameManager.roundCompleted,
      builder: (_, roundCompleted, __) {
        return Stack(
          children: [
            Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/Cloud.png'),
                      ),
                    ),
                  ),
            SafeArea(
              child: Center(
                child: GridView.builder(
                  itemCount: _gridWords.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.columns,
                  ),
                  itemBuilder: (context, index) => WordTile(
                    index: index,
                    word: _gridWords[index],
                    hasImage: widget.hasImage, // ส่งค่า hasImage ไปยัง WordTile
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<int> _cacheImages() async {
    for (var w in _gridWords) {
      final image = Image.memory(Uint8List.fromList(w.contents));
      await precacheImage(image.image, context);
    }
    return 1;
  }
}
  //         return Selector<GameManager, bool>(
  //           selector: (_, gameManager) => gameManager.roundCompleted,
  //           builder: (_, roundCompleted, __) {
  //             return Stack(
  //               children: [
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                     image: DecorationImage(
  //                       fit: BoxFit.fill,
  //                       image: AssetImage('assets/images/Cloud.png'),
  //                     ),
  //                   ),
  //                 ),
  //                 SafeArea(
  //                   child: Center(
  //                     child: GridView.builder(
  //                       shrinkWrap: true,
  //                       itemCount: widget.rows * widget.columns,
  //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: widget.columns, // จำนวนคอลัมน์
  //                         crossAxisSpacing: 10,
  //                         mainAxisSpacing: 10,
  //                         mainAxisExtent: size.height * 0.38,
  //                       ),
  //                       itemBuilder: (context, index) => WordTile(
  //                         index: index,
  //                         word: _gridWords[index],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 ConfettiAnimation(animate: roundCompleted)
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
