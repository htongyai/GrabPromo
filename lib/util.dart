import 'package:audioplayers/audioplayers.dart';

bool english = true;
final AudioPlayer clickPlayer = AudioPlayer();
final AudioPlayer startPlayer = AudioPlayer();
final AudioPlayer correctPlayer = AudioPlayer();
final AudioPlayer wrongPlayer = AudioPlayer();
final AudioPlayer countdownPlayer = AudioPlayer();
final AudioPlayer endPlayer = AudioPlayer();

void buttonSound() {
  clickPlayer.play(
      AssetSource("sound/click.mp3")); // Ensure this file exists in assets
}

void startSound() {
  startPlayer.play(
      AssetSource("sound/start.mp3")); // Ensure this file exists in assets
}

void correntSound() {
  correctPlayer.play(
      AssetSource("sound/correct.mp3")); // Ensure this file exists in assets
}

void wrongSound() {
  wrongPlayer.play(
      AssetSource("sound/wrong.mp3")); // Ensure this file exists in assets
}

void countdownSound() {
  countdownPlayer.play(
      AssetSource("sound/countdown.mp3")); // Ensure this file exists in assets
}

void explosionSound() {
  endPlayer
      .play(AssetSource("sound/end.mp3")); // Ensure this file exists in assets
}

void dispose() {
  clickPlayer.dispose();
  startPlayer.dispose();
  correctPlayer.dispose();
  wrongPlayer.dispose();
  countdownPlayer.dispose();
  endPlayer.dispose();
}
