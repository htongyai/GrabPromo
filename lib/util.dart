import 'package:audioplayers/audioplayers.dart';

bool english = false;

void _playSound(String SoundAssetName) {
  final player = AudioPlayer();
  player.play(AssetSource(SoundAssetName)); // Ensure this file exists in assets
}
