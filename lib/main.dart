import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/Start_page.dart';
import 'package:grabpromogame/firebase_options.dart';
import 'package:grabpromogame/util.dart';
import 'package:window_manager/window_manager.dart';

const Color grabGreen = Color.fromRGBO(0, 177, 79, 1);

/// Portrait aspect ratio of the TR3DK kiosk display (2160 x 3840).
const double kioskAspect = 9 / 16;

bool get _isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 8));
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase init failed (leaderboard offline): $e');
  }

  // Kiosk full-screen mode only applies to desktop builds.
  if (_isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(null, () async {
      await windowManager.setFullScreen(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  initializeAudioPlayers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grab Hot-Deals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: grabGreen),
        primaryColor: grabGreen,
        useMaterial3: true,
        fontFamily: 'GrabCommunitySolidTH',
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        }),
      ),
      // Every screen is laid out relative to MediaQuery size for a portrait
      // kiosk. On landscape/desktop browsers, render inside a centred
      // portrait frame so the layout stays faithful.
      builder: (context, child) => KioskFrame(child: child!),
      home: const StartScreen(),
    );
  }
}

class KioskFrame extends StatelessWidget {
  const KioskFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    // Phones (incl. with browser chrome) and portrait kiosks fill the screen.
    if (size.width / size.height <= 0.75) return child;

    final h = size.height;
    final w = h * kioskAspect;
    return ColoredBox(
      color: const Color(0xFF0B3D2A),
      child: Center(
        child: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 40),
          ]),
          child: ClipRect(
            child: MediaQuery(
              data: mq.copyWith(size: Size(w, h), padding: EdgeInsets.zero),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
