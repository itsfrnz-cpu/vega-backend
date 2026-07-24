import 'package:audioplayers/audioplayers.dart';

class VegaAudio {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playChime() async {
    await _player.play(
      AssetSource('audio/vega_chime.mp3'),
    );
  }
}