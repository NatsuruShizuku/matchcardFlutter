
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class LoadingPage extends StatelessWidget {
//   const LoadingPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: AssetImage('assets/images/Cloud.png')
//             )
//         ),
//         child: const Center(child: CircularProgressIndicator()));
  
//   }
// }
// loading_page.dart
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              'กำลังโหลดข้อมูล...',
              style: GoogleFonts.chakraPetch(
                fontSize: 20,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}