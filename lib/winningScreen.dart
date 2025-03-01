import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/namesubmission.dart';
import 'package:grabpromogame/util.dart';

class WinningScreen extends StatefulWidget {
  WinningScreen(this.collectedDiscounts, this.durationInSeconds,
      this.durationInMilliseconds,
      {super.key});
  int collectedDiscounts;
  int durationInSeconds;
  int durationInMilliseconds;

  @override
  State<WinningScreen> createState() => _WinningScreenState();
}

class _WinningScreenState extends State<WinningScreen> {
  late ConfettiController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        ConfettiController(duration: const Duration(milliseconds: 200));
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        //_startConfetti();
      });
    });
  }

  void _startConfetti() {
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    _startConfetti();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.00),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(215, 251, 219, 1),
                  borderRadius: BorderRadius.circular(screenWidth),
                ),
                height: screenWidth * 0.4,
                width: screenWidth * 0.4,
                child: Center(
                  child: Container(
                    height: screenWidth * 0.25,
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                          image: AssetImage("assets/winningicon.png"),
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.bottomCenter),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                english ? "Congratulatons!" : 'ยินดีด้วย',
                style: TextStyle(
                    fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
              ),
              //  SizedBox(height: screenHeight * 0.0105),
              Text(
                textAlign: TextAlign.center,
                english
                    ? "You have successfully collected all the Hot Deals."
                    : 'คุณเก็บ Hot Deal ได้ครบตามกำหนด',
                style: TextStyle(
                    fontSize: screenWidth * 0.045, color: Colors.black54),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(
                      color: const Color.fromRGBO(219, 219, 219, 1), width: 4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          english
                              ? "80% Promo Collected"
                              : 'ส่วนลด 80% ที่เก็บได้',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black54),
                        ),
                        Text(
                          'x${widget.collectedDiscounts}',
                          style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: screenWidth * 0.13,
                          width: screenWidth * 0.13,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/percent.png"),
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.bottomCenter),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(180)),
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.085),
                ),
                onPressed: () {
                  buttonSound();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NameSubmissionScreen(
                                score: widget.collectedDiscounts,
                                durationInMilliseconds:
                                    widget.durationInMilliseconds,
                                durationInSeconds: widget.durationInSeconds,
                              )));
                },
                child: Text(
                  english ? "Next" : 'ถัดไป',
                  style: TextStyle(
                      fontSize: screenWidth * 0.06, color: Colors.white),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              child: ConfettiWidget(
                minimumSize: const Size(50, 50),
                maximumSize: const Size(100, 100),
                confettiController: _controller,
                blastDirection: pi / 2, // Confetti falls downward
                emissionFrequency: 1,
                numberOfParticles: 100,
                maxBlastForce: 850,
                minBlastForce: 630,
                gravity: 1,
                colors: [
                  Colors.green.shade200,
                  Colors.green.shade400,
                  Colors.green.shade600,
                  Colors.green.shade800,
                  Colors.green.shade900,
                ],
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
