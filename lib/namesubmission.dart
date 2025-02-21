import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/leaderboard.dart';
import 'package:grabpromogame/loadingscreen.dart';
import 'package:grabpromogame/util.dart';

class NameSubmissionScreen extends StatefulWidget {
  final int score;
  const NameSubmissionScreen({super.key, required this.score});

  @override
  _NameSubmissionScreenState createState() => _NameSubmissionScreenState();
}

class _NameSubmissionScreenState extends State<NameSubmissionScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _loading = false;
  void _submitName() async {
    setState(() {
      _loading = true;
    });
    String playerSessionID = _nameController.text + DateTime.now().toString();
    if (_nameController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('testLeaderboard')
            .doc(playerSessionID)
            .set({
          'playerSessionID': playerSessionID,
          'name': _nameController.text,
          'score': widget.score, // Example score, replace with actual score
          'timestamp': FieldValue.serverTimestamp(),
        }).then((_) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (mounted) {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderboardScreen(playerSessionID),
                  ),
                );
              });
            }
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
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _loading
            ? const LoadingScreen()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      english ? 'Please Enter your name' : 'โปรดระบุชื่อ',
                      style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: screenHeight * 0.01),
                    Text(
                      english
                          ? 'for our leaderboard'
                          : 'สำหรับกระดานคะแนนของเรา',
                      style: TextStyle(
                          fontSize: screenWidth * 0.05, color: Colors.black54),
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(thickness: 2, color: Colors.black54),
                    SizedBox(height: screenHeight * 0.05),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        minimumSize:
                            Size(screenWidth * 0.85, screenHeight * 0.08),
                      ),
                      onPressed: _submitName,
                      child: Text(
                        english ? "Next" : 'ถัดไป',
                        style: TextStyle(
                            fontSize: screenWidth * 0.05, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
