// // gamelevel.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/page/game_page.dart';

// class GameLevel extends StatelessWidget {
//   final bool hasImage; // รับค่าจาก SelectGame
//   const GameLevel({super.key, required this.hasImage});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('เลือกระดับเกม')),
      
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 1.5,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         padding: const EdgeInsets.all(10),
//         itemCount: 8, // 2x2 ถึง 2x9
//         itemBuilder: (context, index) {
//           final level = index + 2; // 2x2, 2x3, ..., 2x9
//           return _buildLevelButton(context, '2x$level', 2, level);
//         },
//       ),
//     );
//   }

//   Widget _buildLevelButton(
//       BuildContext context, String label, int rows, int columns) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GamePage(rows: rows, columns: columns,hasImage: hasImage,),
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.all(20), // ระยะห่างภายในปุ่ม
//         textStyle: const TextStyle(fontSize: 20), // ขนาดตัวอักษร
//       ),
//       child: Text(label),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_0/page/game_page.dart';

class GameLevel extends StatelessWidget {
  final bool hasImage; // รับค่าจาก SelectGame
  const GameLevel({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    // รายการระดับเกมที่ต้องการแสดง (6 รายการ)
    final List<Map<String, int>> levelSettings = [
      {'rows': 2, 'columns': 2}, //4
      {'rows': 2, 'columns': 3}, //6
      {'rows': 5, 'columns': 2}, //8
      {'rows': 3, 'columns': 4}, //12
      {'rows': 4, 'columns': 4}, //16
      {'rows': 4, 'columns': 5}, //20
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกระดับเกม'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // กำหนดให้ Grid แสดงผลเป็น 2 คอลัมน์
            const int crossAxisCount = 2;
            final int totalItems = levelSettings.length; // จำนวนรายการ 6
            final int rowCount = (totalItems / crossAxisCount).ceil(); // จำนวนแถว = 3

            // กำหนด spacing ระหว่างปุ่ม
            const double crossAxisSpacing = 10;
            const double mainAxisSpacing = 10;

            // คำนวณความสูงที่มีอยู่จริงหลังจากหัก spacing และ padding แนวตั้ง
            double totalSpacingHeight = mainAxisSpacing * (rowCount - 1);
            double availableHeight = constraints.maxHeight - totalSpacingHeight - 20; // หัก padding แนวตั้ง
            double itemHeight = availableHeight / rowCount;

            // คำนวณความกว้างของแต่ละปุ่ม
            double totalCrossSpacing = crossAxisSpacing * (crossAxisCount - 1);
            double availableWidth = constraints.maxWidth - 20 - totalCrossSpacing; // หัก padding แนวนอน
            double itemWidth = availableWidth / crossAxisCount;

            // childAspectRatio สำหรับ GridView
            double ratio = itemWidth / itemHeight;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: ratio,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                final level = levelSettings[index];
                final label = '${level['rows']}x${level['columns']}';
                return _buildLevelButton(
                  context, 
                  label, 
                  level['rows']!, 
                  level['columns']!
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLevelButton(
      BuildContext context, String label, int rows, int columns) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(
              rows: rows,
              columns: columns,
              hasImage: hasImage,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }
}
