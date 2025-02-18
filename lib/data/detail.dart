// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/model_info.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Details extends StatefulWidget {
//   const Details({
//     super.key,
//     required this.topic,
//   });
//   final Information topic;

//   @override
//   State<Details> createState() => _DetailsState();
// }

// class _DetailsState extends State<Details> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: widget.topic.bgColor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20, top: 30),
//               child: CustomButton(
//                 minheight: 50,
//                 minwidth: 50,
//                 icon: Icons.arrow_back_ios_new,
//                 onpressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             Center(
//               child: SizedBox(
//                   height: height * 0.4, child: Hero(tag: widget.topic.image,
//                   child: Image.asset(widget.topic.image))),
//             ),
//             Container(
//               height: height * 0.7,
//               width: width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.topic.subtitle, style: GoogleFonts.chakraPetch(fontSize: 26,color: widget.topic.color,fontWeight: FontWeight.bold),),
//                     SizedBox(height: 20),
//                     Text(widget.topic.description, style: GoogleFonts.chakraPetch(fontSize: 22,color: widget.topic.color),),
                  
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   }

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     super.key,
//     required this.onpressed,
//     required this.minheight,
//     required this.minwidth,
//     required this.icon,
//   });
//   final VoidCallback onpressed;
//   final double minheight;
//   final double minwidth;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return RawMaterialButton(
//       onPressed: onpressed,
//       constraints: BoxConstraints(
//         minHeight: minheight,
//         minWidth: minwidth,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       fillColor: Colors.white,
//       child: Icon(
//         icon,
//       ),
//     );
//   }
// }


