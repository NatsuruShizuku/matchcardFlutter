// class Word {
//   final String text;
//   final String url;
//   bool displayText;

//   Word({required this.text, required this.url, required this.displayText});
// }
import 'package:flutter_application_0/database/database_helper.dart';

class Word {
  final int id;
  final String descrip;
  final List<int> contents;
  final int matraID;
  bool displayText;

  Word({
    required this.id,
    required this.descrip,
    required this.contents,
    required this.matraID,
    this.displayText = false,
  });

  factory Word.fromMap(Map<String, dynamic> map) => Word(
    id: map[DatabaseHelper.columnId],
    descrip: map[DatabaseHelper.columnDescrip],
    contents: map[DatabaseHelper.columnContents],
    matraID: map[DatabaseHelper.columnMatraID],
  );
}