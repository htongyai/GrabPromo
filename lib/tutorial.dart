import 'package:flutter/material.dart';
import 'package:grabpromogame/game_page.dart';
import 'package:grabpromogame/util.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> tutorialPages = [
    {
      'image': 'assets/tutorial.png',
      'title': 'เก็บ Hot deal สูงสุด 80%',
      'description':
          'เก็บส่วนลด 80% ให้ครบ 5 รายการ ภายใน 30 วินาที เพื่อผ่านเกม',
    },
    {
      'image': 'assets/tutorial.png',
      'title': 'ระวังอย่าเก็บผิดนะ!',
      'description': 'หากเก็บส่วนลดที่ไม่ใช่ 80% เวลาจะลดลง 3 วินาที',
    },
    {
      'image': 'assets/tutorial.png',
      'title': 'ยิ่งเก็บมาก ยิ่งได้มาก',
      'description': 'สเก็บส่วนลดให้ได้มากที่สุดเพื่อลุ้นรับรางวัลพิเศษ',
    }
  ];
  final List<Map<String, String>> tutorialPagesEn = [
    {
      'image': 'assets/tutorial.png',
      'title': 'Collect Hot Deals up to 80%',
      'description':
          'Collect five 80% discount deals within 30 seconds to pass the game.',
    },
    {
      'image': 'assets/tutorial.png',
      'title': 'Be careful not to pick the wrong ones!',
      'description':
          'If you collect a discount that is not 80%, your time will be reduced by 3 seconds.',
    },
    {
      'image': 'assets/tutorial.png',
      'title': 'The more you collect, the more you win!',
      'description':
          'Collect as many discounts as possible for a chance to win special prizes.',
    }
  ];
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   //backgroundColor: Colors.green,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: tutorialPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page =
                        english ? tutorialPagesEn[index] : tutorialPages[index];
                    return Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: screenHeight * 0.55,
                          child: ClipPath(
                            clipper: CustomCurveClipper(),
                            child: Container(
                                height: screenHeight * 0.6,
                                child: Image.asset(
                                  page['image']!,
                                  width: screenWidth,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                textAlign: TextAlign.center,
                                page['title']!,
                                style: TextStyle(
                                    fontSize: english
                                        ? screenWidth * 0.07
                                        : screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromRGBO(4, 41, 35, 1)),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Container(
                                width: screenWidth * 0.85,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.027,
                                ),
                                child: Text(
                                  page['description']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: english
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.055,
                                      color: const Color.fromRGBO(
                                          112, 112, 112, 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      tutorialPages.length,
                      (index) => Container(
                        margin: EdgeInsets.all(screenWidth * 0.015),
                        width: screenWidth * 0.03,
                        height: screenWidth * 0.03,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color.fromRGBO(0, 177, 79, 1)
                                : const Color.fromRGBO(234, 233, 233, 1)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 177, 79, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(180)),
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.08),
                ),
                onPressed: () {
                  buttonSound();
                  if (_currentPage == tutorialPages.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PromoSelectionGame()),
                    );
                  } else {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
                child: english
                    ? Text(
                        _currentPage == tutorialPages.length - 1
                            ? 'Start Game'
                            : 'Next',
                        style: TextStyle(
                            fontSize: screenWidth * 0.06, color: Colors.white),
                      )
                    : Text(
                        _currentPage == tutorialPages.length - 1
                            ? 'เริ่มเล่นเกม'
                            : 'ถัดไป',
                        style: TextStyle(
                            fontSize: screenWidth * 0.06, color: Colors.white),
                      ),
              ),
              SizedBox(height: screenHeight * 0.06),
            ],
          ),
          Positioned(
            top: screenWidth * 0.04,
            left: screenWidth * 0.04,
            child: InkWell(
              onTap: () {
                reloadApp(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Icon(
                      Icons.restart_alt,
                      size: screenWidth * 0.05,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 300);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - 300);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
