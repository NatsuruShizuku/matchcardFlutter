import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/animation/confetti_animation.dart';
import 'package:flutter_application_0/components/replay_popup.dart';
import 'package:flutter_application_0/components/word_tile.dart';

import 'package:flutter_application_0/database/database_helper.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'error_page.dart';
import 'loading_page.dart';

class GamePage extends StatefulWidget {
  final int rows;
  final int columns;
  final bool hasImage; // รับค่าโหมดเกม

  const GamePage(
      {super.key,
      required this.rows,
      required this.columns,
      required this.hasImage});

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
    _gameManager = GameManager(
      hasImage: widget.hasImage,
      totalTiles: widget.rows * widget.columns,
    );
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
  //   if (sourceWords.isEmpty) return;

  //   final totalPairs = (widget.rows * widget.columns) ~/ 2;
  //   sourceWords.shuffle();

  //   if (sourceWords.length < totalPairs) {
  //     throw Exception('ไม่พบคำศัพท์เพียงพอในฐานข้อมูล');
  //   }

  //   for (int i = 0; i < totalPairs; i++) {
  //     // _gridWords.add(sourceWords[i]);
  //     final originalWord = sourceWords[i];
  //     _gridWords.add(originalWord);

  //     _gridWords.add(
  //     Word(
  //       id: originalWord.id,
  //       descrip: originalWord.descrip,
  //       contents: [],
  //       matraID: originalWord.matraID,
  //       displayText: true,
  //     ),
  //   );
  //   }
  //   _gridWords.shuffle();
  // }
  _setUp() {
    if (sourceWords.isEmpty) return;

    final totalPairs = (widget.rows * widget.columns) ~/ 2;

    // จัดกลุ่มคำตาม matraID
    Map<int, List<Word>> groups = {};
    for (Word word in sourceWords) {
      groups.putIfAbsent(word.matraID, () => []).add(word);
    }

    // สร้างรายการคู่คำที่มี matraID เดียวกัน
    List<List<Word>> validPairs = [];
    groups.forEach((matraID, wordsList) {
      if (wordsList.length >= 2) {
        // สุ่มคำภายในกลุ่มนั้น ๆ
        wordsList.shuffle();
        // จำนวนคู่ที่สามารถจับได้ในกลุ่มนี้
        int numPairs = wordsList.length ~/ 2;
        for (int i = 0; i < numPairs; i++) {
          validPairs.add([wordsList[2 * i], wordsList[2 * i + 1]]);
        }
      }
    });

    // ตรวจสอบว่ามีจำนวนคู่ที่เพียงพอหรือไม่
    if (validPairs.length < totalPairs) {
      throw Exception(
          'ไม่พบคำศัพท์เพียงพอในฐานข้อมูลที่มี matraID เดียวกันสำหรับจับคู่');
    }

    // สุ่มเลือกคู่คำที่ต้องการให้ครบจำนวน
    validPairs.shuffle();
    List<List<Word>> selectedPairs = validPairs.take(totalPairs).toList();

    // นำคู่คำที่เลือกมาใส่ใน _gridWords แล้วสลับตำแหน่งเพื่อให้ตำแหน่งของคู่คำแสดงผลแบบสุ่ม
    _gridWords.clear();
    for (List<Word> pair in selectedPairs) {
      _gridWords.addAll(pair);
    }
    _gridWords.shuffle();
  }

  Widget _buildImage(List<int> bytes) {
    return Image.memory(
      Uint8List.fromList(bytes),
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameManager>.value(
      value: _gameManager,
      child: FutureBuilder(
        future: _futureCachedImages,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const ErrorPage();

          // ถ้าเป็นโหมดคำศัพท์ หรือโหลดภาพเสร็จแล้ว
          final isDataReady = !widget.hasImage ||
              snapshot.connectionState == ConnectionState.done;

          if (isDataReady) {
            return Scaffold(
              body: _buildGameGrid(),
            );
          }

          return const LoadingPage();
        },
      ),
    );
  }

  Widget _buildGameGrid() {
    return Selector<GameManager, bool>(
      selector: (_, gameManager) => gameManager.roundCompleted,
      builder: (_, roundCompleted, __) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {
            if (roundCompleted) {
              await showDialog(
                  barrierColor: Colors.transparent,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const ReplayPopUp());
            }
          },
        );

        return Column(
          children: [
            // ส่วนหัวสถิติ
            _buildStatsHeader(),
            // ส่วนกริดการ์ด
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardSize = constraints.maxWidth / widget.columns;
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _gridWords.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.columns,
                        childAspectRatio: 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      // itemBuilder: (context, index) {
                      //   final isMatched = _gameManager.answeredWords.contains(index);
                      //   return SizedBox(
                      //     width: cardSize,
                      //     height: cardSize,
                      //     child: WordTile(
                      //       index: index,
                      //       word: _gridWords[index],
                      //       hasImage: widget.hasImage,
                      //       isMatched: isMatched,
                      //     ),
                      //   );
                      // },
                      itemBuilder: (context, index) {
                        final isMatched =
                            _gameManager.answeredWords.contains(index);
                        return WordTile(
                          // เพิ่ม const ตรงนี้|
                          index: index,
                          word: _gridWords[index],
                          hasImage: widget.hasImage,
                          isMatched: isMatched,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// ปรับส่วน _buildStatsHeader()
  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      color: Colors.white.withOpacity(0.9),
      child: Selector<GameManager, (int, int)>(
        selector: (_, gm) => (gm.moves, gm.secondsElapsed),
        builder: (_, stats, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('เวลา', '${stats.$2} วินาที'),
              _buildStatCard('เคลื่อนไหว', '${stats.$1} ครั้ง'),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildGameGrid() {
  //   final size = MediaQuery.of(context).size;
  //   return Selector<GameManager, bool>(
  //     selector: (_, gameManager) => gameManager.roundCompleted,
  //     builder: (_, roundCompleted, __) {
  //       WidgetsBinding.instance.addPostFrameCallback(
  //         (timeStamp) async {
  //           if (roundCompleted) {
  //             await showDialog(
  //                 barrierColor: Colors.transparent,
  //                 barrierDismissible: false,
  //                 context: context,
  //                 builder: (context) => const ReplayPopUp());
  //           }
  //         },
  //       );

  //       return Stack(
  //         children: [
  //           Container(
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 fit: BoxFit.fill,
  //                 image: AssetImage('assets/images/Cloud.png'),
  //               ),
  //             ),
  //           ),
  //           _buildStatsHeader(),
  //           SafeArea(
  //             child: Center(

  //                child: GridView.builder(
  //               itemCount: _gridWords.length,
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: widget.columns,
  //                 childAspectRatio: 1,
  //                 mainAxisSpacing: 10,
  //                 crossAxisSpacing: 10,
  //               ),
  //               itemBuilder: (context, index) {
  //                 final isMatched = _gameManager.answeredWords.contains(index);
  //                 return WordTile(
  //                   index: index,
  //                   word: _gridWords[index],
  //                   hasImage: widget.hasImage,
  //                   isMatched: isMatched,
  //                 );
  //               },

  //               ),

  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget _buildStatsHeader() {
  //   return Positioned(
  //     top: 20,
  //     left: 0,
  //     right: 0,
  //     child: Selector<GameManager, (int, int)>(
  //       selector: (_, gm) => (gm.moves, gm.secondsElapsed),
  //       builder: (_, stats, __) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               _buildStatCard('เวลา', '${stats.$2} วินาที'),
  //               _buildStatCard('เคลื่อนไหว', '${stats.$1} ครั้ง'),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.chakraPetch(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.chakraPetch(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
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
