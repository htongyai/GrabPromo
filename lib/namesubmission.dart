import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/leaderboard.dart';
import 'package:grabpromogame/loadingscreen.dart';
import 'package:grabpromogame/util.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class NameSubmissionScreen extends StatefulWidget {
  final int score;
  final int durationInSeconds;
  final int durationInMilliseconds;

  const NameSubmissionScreen({
    super.key,
    required this.score,
    required this.durationInSeconds,
    required this.durationInMilliseconds,
  });

  @override
  _NameSubmissionScreenState createState() => _NameSubmissionScreenState();
}

class _NameSubmissionScreenState extends State<NameSubmissionScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _loading = false;
  bool caps = true;
  Future<int> updateHighScore(int newScore) async {
    try {
      DocumentReference leaderboardRef =
          FirebaseFirestore.instance.collection('EventInfo').doc('Leaderboard');

      // Fetch current high score
      DocumentSnapshot snapshot = await leaderboardRef.get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int currentHighScore = data["highScore"] ?? 0;

        // Compare and update if new score is higher
        if (newScore > currentHighScore) {
          await leaderboardRef.update({"highScore": newScore});
          print("🎉 New high score: $newScore updated in Firestore!");
          return newScore;
        } else {
          print(
              "❌ Score not high enough. Current high score: $currentHighScore");
          return currentHighScore;
        }
      } else {
        // If no high score exists, create one
        await leaderboardRef.set({"highScore": newScore});
        print("🏆 First high score set: $newScore");
        return newScore;
      }
    } catch (e) {
      print("⚠️ Error updating high score: $e");
      return newScore;
    }
  }

  void _submitName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _loading) return;
    setState(() => _loading = true);
    final String playerSessionID =
        '${name.replaceAll('/', '')}${DateTime.now()}';
    final entry = {
      'playerSessionID': playerSessionID,
      'name': name,
      'score': widget.score,
      'durationS': widget.durationInSeconds,
      'durationMs': widget.durationInMilliseconds,
    };
    localScores.add(entry);
    int passingScore = widget.score;
    if (firebaseReady) {
      try {
        await FirebaseFirestore.instance
            .collection('testLeaderboard2')
            .doc(playerSessionID)
            .set({...entry, 'timestamp': FieldValue.serverTimestamp()})
            .timeout(const Duration(seconds: 6));
        passingScore = await updateHighScore(widget.score)
            .timeout(const Duration(seconds: 6), onTimeout: () => widget.score);
      } catch (error) {
        // Offline: fall back to the session-local leaderboard.
        debugPrint("Firestore Error, using local leaderboard: $error");
        firebaseReady = false;
      }
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardScreen(
          highScore: passingScore,
          playerSessionID: playerSessionID,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _loading
            ? const LoadingScreen()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.2,
                      ),
                      Text(
                        english
                            ? 'Please enter your name'
                            : 'โปรดระบุชื่อของคุณ',
                        style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            color: const Color.fromRGBO(4, 41, 35, 1),
                            fontWeight: FontWeight.bold),
                      ),
                      // SizedBox(height: screenHeight * 0.01),
                      Text(
                        english
                            ? 'To be listed among the game winners.'
                            : 'เพื่อลงรายชื่อผู้ชนะเกม',
                        style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Color.fromRGBO(112, 112, 112, 1)),
                      ),
                      SizedBox(height: screenWidth * 0.05),
                      TextField(
                        maxLines: 1,
                        maxLength: 6,
                        autofocus: true,
                        textCapitalization: TextCapitalization.characters,
                        onSubmitted: (_) => _submitName(),
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: english ? 'NAME' : 'ชื่อ',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(210, 210, 210, 1)),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: const Divider(
                            thickness: 6,
                            color: Color.fromRGBO(219, 219, 219, 1)),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(180)),
                          minimumSize:
                              Size(screenWidth * 0.85, screenHeight * 0.08),
                        ),
                        onPressed: () {
                          buttonSound();
                          if (_nameController.text.isNotEmpty) {
                            _submitName();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(english ? "Please enter your name" : "กรุณาระบุชื่อ"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        child: Text(
                          english ? "Confirm" : 'ยืนยัน',
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    height: screenHeight * 0.3,
                    child: VirtualKeyboard( 
                      alwaysCaps: caps,
                      height: screenHeight * 0.3,
                      fontSize: screenWidth * 0.03,
                      postKeyPress: (a) {
                        setState(() {

                              String text = _nameController.text;
    
    if (a.keyType == VirtualKeyboardKeyType.String) {
        if (text.length >= 6) {
          // respect the 6-character limit
        } else if (_nameController.text.isEmpty) {
                            a.capsText;

                            _nameController.text +=
                                (a.text?.toUpperCase() ?? "");
                            caps = false;
                          } else{
 _nameController.text += a.text!;
                          }
      // Append the key value to the text
     
    } else if (a.keyType == VirtualKeyboardKeyType.Action &&
        a.action == VirtualKeyboardKeyAction.Backspace) {
      // Handle backspace
      if (text.isNotEmpty) {
        _nameController.text = text.substring(0, text.length - 1);
        if (_nameController.text.isEmpty) caps = true;
      }
    }

    // Move cursor to the end after editing text
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameController.text.length),
    );
                         
                        
                          //else {
                          //   _nameController.text += a.text ?? "";
                          // }
                        });
                      },
                      type: VirtualKeyboardType.Alphanumeric,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
