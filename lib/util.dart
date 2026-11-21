import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/Start_page.dart';

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

/// Returns to the start screen, clearing the navigation stack.
void reloadApp(BuildContext context) {
  buttonSound();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const StartScreen()),
    (route) => false,
  );
}

/// Plays a sound, swallowing errors (e.g. browser autoplay restrictions)
/// so audio problems never break gameplay.
void _play(AudioPlayer player, String asset) {
  player.stop().then((_) => player.play(AssetSource(asset))).catchError((e) {
    debugPrint('Audio error ($asset): $e');
  });
}

void buttonSound() => _play(clickPlayer, 'sound/click.mp3');
void startSound() => _play(startPlayer, 'sound/start.mp3');
void correntSound() => _play(correctPlayer, 'sound/correct.mp3');
void wrongSound() => _play(wrongPlayer, 'sound/wrong.mp3');
void countdownSound() => _play(countdownPlayer, 'sound/countdown.mp3');
void explosionSound() => _play(endPlayer, 'sound/end.mp3');

String formatDuration(int totalMs) {
  if (totalMs <= 0) return '—';
  final s = (totalMs ~/ 1000).toString().padLeft(2, '0');
  final cs = ((totalMs % 1000) ~/ 10).toString().padLeft(2, '0');
  return '$s.$cs s';
}

/// True once Firebase initialised; when false the game runs in offline/demo
/// mode and the leaderboard is kept in memory for this session.
bool firebaseReady = false;

/// Session-local scores, used when Firestore is unreachable.
final List<Map<String, dynamic>> localScores = [
  // Event-day top 3 (Grab Hot Deals, 5 Mar 2025); times were not kept.
  {
    'playerSessionID': 'event-1',
    'name': 'NATTY',
    'score': 12,
    'durationS': 0,
    'durationMs': 0
  },
  {
    'playerSessionID': 'event-2',
    'name': 'MEW',
    'score': 9,
    'durationS': 0,
    'durationMs': 0
  },
  {
    'playerSessionID': 'event-3',
    'name': 'PAVINA',
    'score': 9,
    'durationS': 0,
    'durationMs': 0
  },
];

/// Local leaderboard, sorted like the Firestore query
/// (score desc, then fastest time).
List<Map<String, dynamic>> rankedLocalScores() {
  final list = [...localScores]..sort((a, b) {
      final s = (b['score'] as int).compareTo(a['score'] as int);
      if (s != 0) return s;
      // Unknown times (0) sort after recorded ones.
      final am = a['durationMs'] as int, bm = b['durationMs'] as int;
      return (am == 0 ? 1 << 30 : am).compareTo(bm == 0 ? 1 << 30 : bm);
    });
  return [
    for (var i = 0; i < list.length; i++)
      {
        'playerID': list[i]['playerSessionID'],
        'rank': i + 1,
        'name': list[i]['name'],
        'score': list[i]['score'],
        'sec': list[i]['durationS'],
        'mSec': list[i]['durationMs'],
      }
  ];
}
