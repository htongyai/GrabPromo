import 'package:audioplayers/audioplayers.dart';

bool english = false;
 //final player = AudioPlayer();

void buttonSound() {
  final Clickplayer = AudioPlayer();
  Clickplayer.play(AssetSource("sound/click.mp3")); // Ensure this file exists in assets
}
void startSound() {
  final startplayer = AudioPlayer();
  startplayer.play(AssetSource("sound/start.mp3")); // Ensure this file exists in assets
}

void correntSound() {
  final Cplayer = AudioPlayer();
  Cplayer.play(AssetSource("sound/correct.mp3")); // Ensure this file exists in assets
}

void wrongSound() {
  final Wplayer = AudioPlayer();
  Wplayer.play(AssetSource("sound/wrong.mp3")); // Ensure this file exists in assets
}
void countdownSound() {
  final Countplayer = AudioPlayer();
  Countplayer.play(AssetSource("sound/countdown.mp3")); // Ensure this file exists in assets
}
void explosionSound() {
  final endPlayer = AudioPlayer();
  endPlayer.play(AssetSource("sound/end.mp3")); // Ensure this file exists in assets
}