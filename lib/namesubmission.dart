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
    setState(() {
      _loading = true;
    });
    String playerSessionID = _nameController.text + DateTime.now().toString();
    if (_nameController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('testLeaderboard2')
            .doc(playerSessionID)
            .set({
          'playerSessionID': playerSessionID,
          'name': _nameController.text,
          'score': widget.score, // Example score, replace with actual score
          'timestamp': FieldValue.serverTimestamp(),
          'durationS': widget.durationInSeconds,
          'durationMs': widget.durationInMilliseconds
        }).then((_) {
          updateHighScore(widget.score).then((passingScore) {
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(
                        highScore: passingScore,
                        playerSessionID: playerSessionID,
                      ),
                    ),
                  );
                });
              }
            });
          });
        });
      } catch (error) {
        debugPrint("Firestore Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save data: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    // else {
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   const SnackBar(
    //   //     content: Text("Name cannot be empty!"),
    //   //     backgroundColor: Colors.orange,
    //   //   ),
    //   // );
    // }
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
                            ? 'Please Enter your name'
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
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: const Divider(
                            thickness: 10,
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
                              const SnackBar(
                                content: Text("Name cannot be empty!"),
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
                      borderRadius: BorderRadius.circular(90),
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
                          if (_nameController.text.isEmpty) {
                            a.capsText;

                            _nameController.text +=
                                (a.text?.toUpperCase() ?? "");
                            caps = false;
                          } else {
                            _nameController.text += a.text ?? "";
                          }
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
