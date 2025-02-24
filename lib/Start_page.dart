import 'package:flutter/material.dart';
import 'package:grabpromogame/tutorial.dart';
import 'package:grabpromogame/util.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    String name = 'empty';
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
      body: Center(
        child: Container(height: screenHeight,width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               SizedBox(
                  height: screenHeight * 0.1,
                ),
              Image.asset('assets/title.png', width: screenWidth * 0.6),
              const Spacer(),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(180)),
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.08),
                ),
                onPressed: () {
                buttonSound();
                  english = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialScreen()),
                  );
                },
                child: Text(
                  'ภาษาไทย',
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(0, 177, 79, 1)),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(180)),
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.08)),
                onPressed: () { buttonSound();
                  english = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialScreen()),
                  );
                },
                child: Text(
                  'English',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.06,
                      color: const Color.fromRGBO(0, 177, 79, 1)),
                ),
              ),
               SizedBox(
                height: screenHeight * 0.03,
              ),
              Text(
                'Powered by CON-XO Lab',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.025,
                    fontWeight: FontWeight.w700),
              ),
            SizedBox(
                height: screenHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
