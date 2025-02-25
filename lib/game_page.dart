import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/losingScreen.dart';
import 'package:grabpromogame/resteraunt_data.dart';
import 'package:grabpromogame/util.dart';
import 'package:grabpromogame/winningScreen.dart';
import 'package:lottie/lottie.dart';

class Restaurant {
  final String promoName;
  final String name;
  final String imageUrl;
  final int discount;

  Restaurant(this.promoName, this.name, this.imageUrl, this.discount);
}

class PromoSelectionGame extends StatefulWidget {
  const PromoSelectionGame({super.key});

  @override
  _PromoSelectionGameState createState() => _PromoSelectionGameState();
}

class _PromoSelectionGameState extends State<PromoSelectionGame>
    with TickerProviderStateMixin {
  List<Restaurant> restaurants = [];
  Set<String> selectedRestaurants = {};
  Set<String> selectedRestaurants2 = {};
  int selectedCount = 0;
  bool gameOver = false;
  Timer? _timer;
  int _timeLeft = 30;
  bool right = false;
  //double progress = 1.0;
  // bool showWrongSelectionGraphic = false;
  bool _showCountdownOverlay = true;
  bool _showEndOverlay = false;
  int _countdown = 3;
  Color selectedColor = Colors.white;
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _backgroundScaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _colorAnimation2;
  late Animation<Color?> _colorAnimationText;
  late Animation<Color?> _colorAnimationText2;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController2;
  late Animation<double> _scaleAnimation2;
  late AnimationController _starController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _timeShakesController;
  late Animation<double> _timeShakesAnimation;
  late Animation<Color?> _timeColorAnimation;
  late Animation<Color?> _timeColorAnimationFinal;
  late AnimationController sparkController;
  bool collectedShow = false;
  final player = AudioPlayer();
  List<Star> stars = [];
  @override
  void initState() {
    super.initState();
    sparkController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    loadRestaurants();
    restaurants.shuffle(Random());
    startSound();
    startCountdownOverlay();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Total shake time
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _timeShakesController = AnimationController(
      duration: const Duration(milliseconds: 230),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timeShakesController.reverse(); // Reverse back after completion
        }
      });

    _timeShakesAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _timeShakesController, curve: Curves.bounceIn));

    _timeColorAnimation = ColorTween(
      begin: const Color.fromRGBO(229, 88, 75, 1),
      end: Colors.red.shade900,
    ).animate(CurvedAnimation(
        parent: _timeShakesController, curve: Curves.easeInOut));
    _timeColorAnimationFinal = ColorTween(
      begin: const Color.fromRGBO(0, 85, 55, 1),
      end: Colors.red.shade900,
    ).animate(CurvedAnimation(
        parent: _timeShakesController, curve: Curves.easeInOut));
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: ConstantTween(const Offset(3, 0.0)), // Stay for 3 seconds
        weight: 3,
      ),
    ]).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_controller);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200), // Total animation time
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              _bounceController.reverse(); // Return to blue
            }
          });
        }
      });

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -20), weight: 1),
    ]).animate(_bounceController);

    _backgroundScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: const Color.fromRGBO(235, 239, 244, 1),
      end: const Color.fromRGBO(0, 177, 79, 1),
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
    _colorAnimationText = ColorTween(
      begin: const Color.fromRGBO(4, 41, 35, 1),
      end: const Color.fromRGBO(235, 239, 244, 1),
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    _scaleController = AnimationController(
      duration:
          const Duration(milliseconds: 200), // Duration of the scale effect
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleController.reverse(); // Shrinks back after expansion
        }
      });

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25, // Scale up
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    _starController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _scaleController2 = AnimationController(
      duration:
          const Duration(milliseconds: 200), // Duration of the scale effect
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleController2.reverse(); // Shrinks back after expansion
        }
      });

    _scaleAnimation2 = Tween<double>(
      begin: 1.0,
      end: 1.25, // Scale up
    ).animate(CurvedAnimation(
      parent: _scaleController2,
      curve: Curves.easeInOut,
    ));
    _colorAnimation2 = ColorTween(
      begin: const Color.fromRGBO(235, 239, 244, 1),
      end: const Color.fromRGBO(0, 177, 79, 1),
    ).animate(CurvedAnimation(
      parent: _scaleController2,
      curve: Curves.easeInOut,
    ));
    _colorAnimationText2 = ColorTween(
      begin: const Color.fromRGBO(4, 41, 35, 1),
      end: const Color.fromRGBO(235, 239, 244, 1),
    ).animate(CurvedAnimation(
      parent: _scaleController2,
      curve: Curves.easeInOut,
    ));
  }

  playColelcted() {
    setState(() {
      collectedShow = true;
    });
    sparkController.forward(from: 0.0);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        collectedShow = false;
        sparkController.stop();
        // showWrongSelectionGraphic = false;
        // selectedColor = Colors.white;
        //selectedRestaurants2.remove(restaurant.promoName);
      });
    });
  }

  void _startTimeShakesAnimation() {
    _timeShakesController.forward();
  }

  void _startStartAnimation() {
    _starController.forward(from: 0);
  }

  void startSAnimation() {
    _scaleController.forward(from: 0);
  }

  void startShake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    _bounceController.dispose();
    _scaleController.dispose();
    _scaleController2.dispose();
    _starController.dispose();
    _slideController.dispose();
    _timeShakesController.dispose();
    sparkController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startCountdownOverlay() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        player.play(AssetSource("sound/bgm.mp3"));
        setState(() {
          _showCountdownOverlay = false;
          startTimer();
        });
      }
    });
  }

  void SlidestartAnimation() {
    _slideController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _slideController.reverse(); // Move back out after 3 seconds
    });
  }

  void startAnimation() {
    _scaleController2.forward(from: 0);
    //_bounceController.forward(from: 0);
  }

  void loadRestaurants() {
    setState(() {
      if (english == true) {
        restaurants = promotionsEnglish
            .map((data) => Restaurant(data["promoName"], data["name"],
                data["imageUrl"], data["discount"]))
            .toList();
      } else {
        restaurants = promotionsThai
            .map((data) => Restaurant(data["promoName"], data["name"],
                data["imageUrl"], data["discount"]))
            .toList();
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
          // progress = _timeLeft / 30;
          if (_timeLeft == 10) {
            // SlidestartAnimation();
            countdownSound();
            // slideIdol();
          }
        });
      } else {
        timer.cancel();
        checkWinCondition();
      }
    });
  }

  void checkWinCondition() {
    _showEndOverlay = true;
    setState(() {});
    player.stop();
    explosionSound();
    gameOver = true;
    _timer?.cancel();
    // showTimeUpScreen();
    if (selectedCount >= 5) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WinningScreen(
                        selectedCount,
                      )));
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LosingScreen(collectedDiscounts: selectedCount)));
        });
      });
    }
  }

  Widget EndScreen() {
    var size = MediaQuery.of(context).size;
    return Lottie.asset(
      'assets/animations/bomb.json',
      repeat: false,
      alignment: Alignment.center,
      width: size.width,
      height: size.height * 0.6,
      fit: BoxFit.cover,
    );
  }

  void showTimeUpScreen() {
    final double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/times_up.png', width: screenWidth * 0.7),
          ],
        ),
      ),
    );
  }

  void selectRestaurant(Restaurant restaurant) {
    if (gameOver || selectedRestaurants.contains(restaurant.promoName)) return;
    setState(() {
      selectedRestaurants.add(restaurant.promoName);
      selectedRestaurants2.add(restaurant.promoName);
      if (restaurant.discount == 80) {
        correntSound();
        playColelcted();
        slideIdol();
        startAnimation();
        startSAnimation();
        _startStartAnimation();
        selectedCount++;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            // collectedShow=false;
            // showWrongSelectionGraphic = false;
            // selectedColor = Colors.white;
            selectedRestaurants2.remove(restaurant.promoName);
          });
        });
      } else {
        wrongSound();
        setState(() {
          selectedColor = const Color.fromRGBO(247, 205, 201, 1);
        });
        startShake();
        _timeLeft = max(0, _timeLeft - 3);
        _startTimeShakesAnimation();
        // showWrongSelectionGraphic = true;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            //   showWrongSelectionGraphic = false;
            selectedColor = Colors.white;
            selectedRestaurants.remove(restaurant.promoName);
          });
        });
      }
    });
  }

  slideIdol() {
    final double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);

    if (right) {
      _slideAnimation = TweenSequence<Offset>([
        TweenSequenceItem(
            tween:
                Tween(begin: const Offset(1, 0.0), end: const Offset(0.0, 0.0)),
            weight: 1),
      ]).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ));
      SlidestartAnimation();
      right = !right;
    } else {
      _slideAnimation = TweenSequence<Offset>([
        TweenSequenceItem(
            tween: Tween(
                begin: const Offset(-2, 0.0), end: const Offset(-1.0, 0.0)),
            weight: 1),
      ]).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ));
      SlidestartAnimation();
      right = !right;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double progress = _timeLeft / 30;
    int selectedIndex = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(title: const Text('Restaurant Promo Selection Game')),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              Container(
                  height: screenHeight * 0.2,
                  width: screenWidth,
                  color: const Color.fromRGBO(0, 177, 79, 1)),
              SizedBox(
                height: screenHeight * 0.8,
                width: screenWidth,
                child: Stack(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.8,
                      width: screenWidth,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.2,
                            bottom: screenHeight * 0.05),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          bool isSelected = selectedRestaurants
                              .contains(restaurant.promoName);
                          bool isSelected2 = selectedRestaurants2
                              .contains(restaurant.promoName);
                          bool isCorrect =
                              isSelected && restaurant.discount == 80;

                          return GestureDetector(
                            onTap: () {
                              selectedIndex = index;
                              print(selectedIndex);
                              print("index$index");
                              selectRestaurant(restaurant);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screenWidth * 0.8,
                              margin:
                                  EdgeInsets.only(top: screenHeight * 0.035),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          color: Colors.grey),
                                      height: screenWidth * 0.25,
                                      width: screenWidth * 0.25,
                                      child: Image.network(restaurant.imageUrl,
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.25,
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.04,
                                    ),
                                    SizedBox(
                                      // height: screenHeight * 0.1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.6,
                                            child: Text(restaurant.promoName,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.6,
                                            child: Text(restaurant.name,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    color: Colors.grey)),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.01,
                                          ),
                                          Stack(
                                            children: [
                                              AnimatedBuilder(
                                                animation: _scaleController,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale: isSelected2 &&
                                                            isCorrect
                                                        ? _scaleAnimation.value
                                                        : 1,
                                                    child: AnimatedBuilder(
                                                      animation:
                                                          _shakeAnimation,
                                                      builder:
                                                          (context, child) {
                                                        return Transform
                                                            .translate(
                                                          offset: isSelected &&
                                                                  !isCorrect
                                                              ? Offset(
                                                                  _shakeAnimation
                                                                      .value,
                                                                  0)
                                                              : const Offset(
                                                                  0, 0),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: screenWidth *
                                                                0.3,
                                                            height:
                                                                screenHeight *
                                                                    0.0475,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isSelected
                                                                  ? (isCorrect
                                                                      ? Colors
                                                                          .green
                                                                      : selectedColor)
                                                                  : Colors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      219,
                                                                      219,
                                                                      219,
                                                                      1),
                                                                  width: 5),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      screenWidth *
                                                                          0.05,
                                                                  width:
                                                                      screenWidth *
                                                                          0.05,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
                                                                            "assets/percent.png"),
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        alignment:
                                                                            Alignment.bottomCenter),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      screenWidth *
                                                                          0.025,
                                                                ),
                                                                Text(
                                                                    '${restaurant.discount}% off',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            screenWidth *
                                                                                0.04,
                                                                        color: isSelected
                                                                            ? (isCorrect
                                                                                ? Colors.white
                                                                                : Colors.black)
                                                                            : const Color.fromRGBO(4, 41, 35, 1),
                                                                        fontWeight: FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_showEndOverlay)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.8),
                          child: Center(child: EndScreen()),
                        ),
                      ),
                    if (_showCountdownOverlay)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.8),
                          child: Center(
                            child: Image.asset(
                              'assets/$_countdown.png',
                              width: screenWidth * 0.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ]),
            Positioned(
              top: screenHeight * 0.1,
              child: Center(
                child: Container(
                  // margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                  width: screenWidth * 0.925,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 80,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(90),
                      //  border: Border.all(color: Colors.grey),
                      color: Colors.white),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              //color: Colors.white,
                              // borderRadius: BorderRadius.circular(12),
                              ),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.009),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: screenHeight * 0.01),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                              english
                                                  ? "Time Left"
                                                  : "เหลือเวลาอีก",
                                              style: TextStyle(
                                                  fontSize: screenWidth * 0.04,
                                                  color: const Color.fromRGBO(
                                                      4, 41, 35, 1),
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        SizedBox(height: screenHeight * 0.008),
                                        AnimatedBuilder(
                                          animation: _timeShakesController,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                  _timeShakesAnimation.value,
                                                  0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: screenWidth * 0.25,
                                                decoration: BoxDecoration(
                                                  color: _timeLeft < 10
                                                      ? _timeColorAnimation
                                                          .value
                                                      : _timeColorAnimationFinal
                                                          .value,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                    _timeLeft < 10
                                                        ? '00:0$_timeLeft'
                                                        : '00:$_timeLeft',
                                                    style: TextStyle(
                                                        letterSpacing: 2,
                                                        fontSize:
                                                            screenWidth * 0.07,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white)),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.0125),
                              Container(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.05),
                                // alignment: Alignment.center,
                                // color: Colors.red,
                                width: screenWidth,
                                height: screenHeight * 0.0325,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.79,
                                      height: screenHeight * 0.01,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(125),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * 0.79 * progress,
                                      height: screenHeight * 0.01,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(
                                                0xFF4ED580), // #4ED580 (Green)
                                            Color(
                                                0xFF00B440), // #00B440 (Darker Green)
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(125),
                                      ),
                                    ),
                                    Positioned(
                                      top: -screenHeight * 0.009,
                                      left: _timeLeft > 5
                                          ? (screenWidth * 0.74) *
                                              (progress - 0.005)
                                          : (screenWidth * 0.74) *
                                              (progress - 0.008),
                                      child: Image.asset(
                                        'assets/slider_selector.png',
                                        width: screenWidth * 0.08,
                                        height: screenWidth * 0.08,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Divider(
                            thickness: 6,
                            height: screenHeight * 0.01,
                            color: Color.fromRGBO(219, 219, 219, 1),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        SizedBox(
                          width: screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: screenWidth * 0.04),
                                    height: screenWidth * 0.1,
                                    width: screenWidth * 0.1,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/percent.png"),
                                          fit: BoxFit.contain,
                                          alignment: Alignment.bottomCenter),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.025,
                                  ),
                                  Text("80% off",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.06,
                                          color: const Color.fromRGBO(
                                              4, 41, 35, 1),
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                height: screenHeight * 0.1,
                                width: screenWidth * 0.2,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _scaleController2,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _scaleAnimation2.value,
                                          child: Center(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: screenHeight * 0.05,
                                              width: screenWidth * 0.15,
                                              // padding: const EdgeInsets.symmetric(
                                              //     horizontal: 25, vertical: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(145),
                                                color: selectedCount >= 5
                                                    ? Colors.green
                                                    : _colorAnimation2.value,
                                              ),
                                              child: Text(
                                                  "x${selectedCount.toString()}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      color: selectedCount >= 5
                                                          ? Colors.white
                                                          : _colorAnimationText2
                                                              .value,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Center(
                                      child: Visibility(
                                        visible: collectedShow,
                                        child: Center(
                                          child: Lottie.asset(
                                              alignment: Alignment.center,
                                              'assets/animations/firework.json',
                                              controller: sparkController,
                                              height: screenHeight * 0.5,
                                              width: screenHeight * 0.4,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/idol1.png"),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.bottomCenter),
                  ),
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.6,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.008,
              right: screenWidth * 0.08,
              child: Container(
                height: screenWidth * 0.35,
                width: screenWidth * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/hotdeal.png"),
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.bottomCenter),
                ),
              ),
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
        ));
  }
}

class Star {
  final double angle;
  final double distance;
  final double size;
  final Color color;

  Star(
      {required this.angle,
      required this.distance,
      required this.size,
      required this.color});
}
