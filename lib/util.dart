import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/losingScreen.dart';
import 'package:grabpromogame/main.dart';

bool english = false;
late AudioPlayer clickPlayer;
late AudioPlayer startPlayer;
late AudioPlayer correctPlayer;
late AudioPlayer wrongPlayer;
late AudioPlayer countdownPlayer;
late AudioPlayer endPlayer;

void initializeAudioPlayers() {
  clickPlayer = AudioPlayer();
  startPlayer = AudioPlayer();
  correctPlayer = AudioPlayer();
  wrongPlayer = AudioPlayer();
  countdownPlayer = AudioPlayer();
  endPlayer = AudioPlayer();
}

void reloadApp(BuildContext context) {
  buttonSound();
  disposeAudioPlayers();
  initializeAudioPlayers();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MyApp()),
    (route) => false,
  );
}

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

void disposeAudioPlayers() {
  clickPlayer.dispose();
  startPlayer.dispose();
  correctPlayer.dispose();
  wrongPlayer.dispose();
  countdownPlayer.dispose();
  endPlayer.dispose();
  print('sound dispose complete');
}
