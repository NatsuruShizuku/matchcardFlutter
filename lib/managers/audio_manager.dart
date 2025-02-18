import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final player = AudioPlayer();

  static Future playAudio(String sounds) async {
    await player.play(AssetSource('sounds/$sounds.mp3'));
  }
}