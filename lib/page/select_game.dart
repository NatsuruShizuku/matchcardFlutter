// select_game.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_0/page/game_level.dart';


class SelectGame extends StatelessWidget {
  const SelectGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกโหมดเกม')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ปุ่มโหมดจับคู่ภาพ (มีรูปภาพและคำศัพท์)
            _buildGameModeButton(
              context,
              'จับคู่ภาพ',
              true, // ส่งค่า hasImage = true
            ),
            const SizedBox(height: 20),
            // ปุ่มโหมดจับคู่คำศัพท์ (มีเพียงข้อความ)
            _buildGameModeButton(
              context,
              'จับคู่คำศัพท์',
              false, // ส่งค่า hasImage = false
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeButton(
    BuildContext context,
    String label,
    bool hasImage,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameLevel(hasImage: hasImage),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: const TextStyle(fontSize: 24),
      ),
      child: Text(label),
    );
  }
}