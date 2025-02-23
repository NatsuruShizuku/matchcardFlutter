import 'package:audioplayers/audioplayers.dart';

// class AudioManager {
//   static final player = AudioPlayer();

//   static Future playAudio(String sounds) async {
//     await player.play(AssetSource('sounds/$sounds.mp3'));
//   }
// }

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String soundName) async {
    await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}