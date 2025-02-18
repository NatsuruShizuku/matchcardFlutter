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
// gamelevel.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_0/page/game_page.dart';

class GameLevel extends StatelessWidget {
  final bool hasImage; // รับค่าจาก SelectGame
  const GameLevel({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
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
            // มีปุ่มทั้งหมด 8 ปุ่ม โดย crossAxisCount = 2 ทำให้ได้ 4 แถว
            int rowCount = 4;
            // คำนวณความสูงรวมของ mainAxisSpacing (10 พิกเซลระหว่างแถว)
            double totalSpacingHeight = 10 * (rowCount - 1);
            // availableHeight คือความสูงที่มีอยู่หลังจากหัก spacing และ padding แนวตั้ง
            double availableHeight = constraints.maxHeight - totalSpacingHeight - 20;
            // ความสูงของแต่ละปุ่ม
            double itemHeight = availableHeight / rowCount;
            // คำนวณความกว้างของแต่ละปุ่ม (หัก padding แนวนอนและ crossAxisSpacing)
            double availableWidth = constraints.maxWidth - 20 - 10;
            double itemWidth = availableWidth / 2;
            // childAspectRatio = itemWidth / itemHeight
            double ratio = itemWidth / itemHeight;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ratio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final level = index + 2; // 2x2, 2x3, ..., 2x9
                return _buildLevelButton(context, '2x$level', 2, level);
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
        foregroundColor: Colors.deepPurple, backgroundColor: Colors.white, // สีข้อความและไอคอน
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
