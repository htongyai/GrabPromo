import 'package:flutter/material.dart';
import 'package:grabpromogame/Start_page.dart';
import 'package:grabpromogame/util.dart';

class LosingScreen extends StatelessWidget {
  final int collectedDiscounts;
  const LosingScreen({super.key, required this.collectedDiscounts});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.03),
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(255, 231, 216, 1),
            radius: screenWidth * 0.15,
            child: Container(
              height: screenWidth * 0.25,
              width: screenWidth * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/loseIcon.png"),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.bottomCenter),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            english ? "Almost there!" : 'อีกแค่นิดเดียวเอง',
            style: TextStyle(
                fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
          ),
          //SizedBox(height: screenHeight * 0.01),
          Text(
            english
                ? "You didn’t collect all the required Hot Deals."
                : 'คุณเก็บ Hot Deals ได้ไม่ครบตามกำหนด',
            style: TextStyle(
                fontSize: english ? screenWidth * 0.04 : screenWidth * 0.05,
                color: Colors.black54),
          ),
          SizedBox(height: screenHeight * 0.05),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
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
                          ? "80% Hot Deals Collected"
                          : 'Hot Deals 80% ที่เก็บได้',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, color: Colors.black54),
                    ),
                    Text(
                      'x$collectedDiscounts',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    //SizedBox(width: screenWidth * 0.01),
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
          SizedBox(height: screenHeight * 0.03),
          Container(
            height: screenHeight * 0.12,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(212, 251, 219, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: screenWidth * 0.015),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        english ? "But don't worry!" : 'แต่ไม่ต้องเสียใจไป!',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        english
                            ? "We have a consolation prize for you!"
                            : 'ไม่เป็นเรามีรางวัลปลอบใจให้คุณนะ!',
                        style: TextStyle(
                            fontSize: english
                                ? screenWidth * 0.035
                                : screenWidth * 0.04,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                // Image.asset('assets/hotdeal.png', width: screenWidth * 0.08),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.08),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(180)),
              minimumSize: Size(screenWidth * 0.8, screenHeight * 0.085),
            ),
            onPressed: () {
              reloadApp(context);
            },
            child: Text(
              english ? "Back start" : 'กลับสู่หน้าแรก',
              style:
                  TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
            ),
          ),
          SizedBox(height: screenHeight * 0.08),
        ],
      ),
    );
  }
}
