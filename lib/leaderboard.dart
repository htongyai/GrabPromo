import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/loadingscreen.dart';
import 'package:grabpromogame/main.dart';
import 'package:grabpromogame/util.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen(
      {required this.playerSessionID, required this.highScore, super.key});
  final String playerSessionID;
  final int highScore;
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<Map<String, dynamic>> leaderboard = const [
    {'rank': 1, 'name': 'NATTY', 'score': 12},
    {'rank': 2, 'name': 'MEW', 'score': 9},
    {'rank': 3, 'name': 'PAVINA', 'score': 9},
  ];
  String tempID = '';
  bool No1 = false;
  bool _loading = true;

  Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
    List<Map<String, dynamic>> leaderboard = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('testLeaderboard2')
          .orderBy('score', descending: true)
          .orderBy('durationS', descending: false)
          .orderBy('durationMs', descending: false)
          .get();

      int rank = 1;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("With time");
        print(data);
        leaderboard.add({
          'playerID': data['playerSessionID'],
          'rank': rank,
          'name': data['name'],
          'score': data['score'],
          'timestamp': data['timestamp'],
        });
        rank++;
      }
    } catch (error) {
      debugPrint("Error fetching leaderboard: $error");
    }
    return leaderboard;
  }

  Future<List<Map<String, dynamic>>> getPlayerData(
      String playerSessionID) async {
    List<Map<String, dynamic>> playerData = [];
    int rank = 1;
    int finalRank = 1;
    try {
      QuerySnapshot querySnapshotA = await FirebaseFirestore.instance
          .collection('testLeaderboard2')
          .orderBy('score', descending: true)
          .get();

      for (var doc in querySnapshotA.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // print(data);
        if (data['playerSessionID'] == playerSessionID) {
          // print(data['score']);
          // print("Checking if match:${widget.highScore}");
          if (data['score'] == widget.highScore) {
            //   print("Match Found");
            No1 = true;
          } else {
            No1 = false;
          }
          //  print("Dound");
          finalRank = rank;

          print(rank);
          //return rank; // Return rank when player is found
        }
        rank++; // Increment rank for next player
      }
    } catch (error) {
      debugPrint("Error fetching player rank: $error");
    }
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('testLeaderboard2')
          .doc(playerSessionID)
          .get();
      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      if (querySnapshot.exists) {
        playerData.add({
          'playerID': data['playerSessionID'],
          'rank': finalRank,
          'name': data['name'],
          'score': data['score'],
          'timestamp': data['timestamp'],
        });
      } else {
        debugPrint("No player data found for session: $playerSessionID");
      }
    } catch (error) {
      debugPrint("Error fetching player data: $error");
    }
    // print(playerData);
    return playerData;
  }

  Future<int> fetchPlayerRank(String playerSessionID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(playerSessionID)
          .orderBy('score', descending: false)
          .get();

      int rank = 0;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['playerSessionID'] == playerSessionID) {
          if (data['score'] == widget.highScore) {
            print("Match Found");
            No1 = true;
          }
          return rank; // Return rank when player is found
        }
        rank++; // Increment rank for next player
      }
    } catch (error) {
      debugPrint("Error fetching player rank: $error");
    }

    return 0; // Return null if player is not found
  }

  @override
  void initState() {
    getPlayerData(widget.playerSessionID).then((rank) {});
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _loading = false;
      });
    });
    // dispose();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeM = MediaQuery.of(context).size.width;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    String name = 'empty';
    int score = 0;
    //getPlayerData(widget.playerSessionID);

    LinearGradient getGradient(rank) {
      switch (rank) {
        case 1:
          return const LinearGradient(
            colors: [Color(0xFFFDDA32), Color(0xFFF5AD03)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 2:
          return const LinearGradient(
            colors: [Color(0xFFD7D7D7), Color(0xFFB6B6B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 3:
          return const LinearGradient(
            colors: [Color(0xFFFDAA77), Color(0xFFC68156)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        default:
          return const LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Column(
                children: [
                  Container(
                    height: screenHeight * 0.18,
                    width: screenWidth,
                    color: const Color.fromRGBO(0, 177, 79, 1),
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.04, bottom: screenHeight * 0.03),
                    child: Column(
                      children: [
                        Text(
                          english ? 'Leaderboard' : 'อันดับคะแนน',
                          style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    SizedBox(
                      height: screenHeight * 0.26,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchLeaderboard(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No leaderboard data available."));
                          }

                          List<Map<String, dynamic>> leaderboard =
                              snapshot.data!;

                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              final player = leaderboard[index];
                              bool isUser = player['playerSessionID'] ==
                                  widget.playerSessionID;

                              return Container(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.075,
                                  //padding: const EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.005),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: isUser
                                        ? Border.all(
                                            color: Colors.green, width: 2)
                                        : Border.all(
                                            color: const Color.fromRGBO(
                                                219, 219, 219, 1),
                                            width: 1),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.075,
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.011,
                                        right: screenWidth * 0.03),
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: screenWidth * 0.05,
                                    //     vertical: screenHeight * 0.005),
                                    decoration: BoxDecoration(
                                        //color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                219, 219, 219, 1),
                                            width: 5)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: screenWidth * 0.1,
                                                  height: screenWidth * 0.1,
                                                  decoration: BoxDecoration(
                                                    gradient: player['score'] ==
                                                            widget.highScore
                                                        ? getGradient(1)
                                                        : getGradient(
                                                            player['rank']),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    player['score'] ==
                                                            widget.highScore
                                                        ? '1'
                                                        : player['rank']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.05,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: screenWidth * 0.05),
                                                child: Text(
                                                  player['name'],
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: screenWidth * 0.08,
                                                width: screenWidth * 0.08,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/percent.png"),
                                                      fit: BoxFit.fitHeight,
                                                      alignment: Alignment
                                                          .bottomCenter),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.1,
                                                child: Text(
                                                  'x${player['score']}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          )
                                        ]),
                                  )

                                  //  ListTile(
                                  //   leading: Container(
                                  //     padding: const EdgeInsets.all(8),
                                  //     width: screenWidth * 0.1,
                                  //     height: screenWidth * 0.1,
                                  //     decoration: BoxDecoration(
                                  //       gradient: getGradient(player['rank']),
                                  //       borderRadius: BorderRadius.circular(10),
                                  //     ),
                                  //     alignment: Alignment.center,
                                  //     child: Text(
                                  //       '${player['rank']}',
                                  //       style: TextStyle(
                                  //           fontSize: screenWidth * 0.04,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.white),
                                  //     ),
                                  //   ),
                                  //   title: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: screenWidth * 0.05),
                                  //     child: Text(
                                  //       player['name'],
                                  //       style: TextStyle(
                                  //           fontSize: screenWidth * 0.045,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //   ),
                                  //   trailing: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       Container(
                                  //         margin:
                                  //             const EdgeInsets.only(right: 10),
                                  //         height: screenWidth * 0.1,
                                  //         width: screenWidth * 0.1,
                                  //         decoration: const BoxDecoration(
                                  //           image: DecorationImage(
                                  //               image: AssetImage(
                                  //                   "assets/percent.png"),
                                  //               fit: BoxFit.fitHeight,
                                  //               alignment:
                                  //                   Alignment.bottomCenter),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         width: screenWidth * 0.07,
                                  //         child: Text(
                                  //           'x${player['score']}',
                                  //           style: TextStyle(
                                  //               fontSize: screenWidth * 0.05,
                                  //               fontWeight: FontWeight.w400),
                                  //           textAlign: TextAlign.center,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.12,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: getPlayerData(widget.playerSessionID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No leaderboard data available."));
                          }

                          List<Map<String, dynamic>> leaderboard =
                              snapshot.data!;

                          return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final player = leaderboard[index];
                              bool isUser = player['playerSessionID'] ==
                                  widget.playerSessionID;
                              if (player['rank'] == 1) {
                                No1 = true;
                              } else {
                                // No1 = false;
                              }

                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01,
                                    ),
                                    color: const Color.fromRGBO(0, 177, 79, 1),
                                    height: screenHeight * 0.003,
                                    width: screenWidth * 0.9,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.075,
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.0075,
                                        right: screenWidth * 0.03),
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: screenWidth * 0.05,
                                    //     vertical: screenHeight * 0.005),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                0, 177, 79, 1),
                                            width: 12)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: screenWidth * 0.11,
                                                  height: screenWidth * 0.11,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        8, 73, 51, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    player['score'] ==
                                                            widget.highScore
                                                        ? '1'
                                                        : player['rank']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.05,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: screenWidth * 0.05),
                                                child: Text(
                                                  player['name'],
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: screenWidth * 0.08,
                                                width: screenWidth * 0.08,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/percent.png"),
                                                      fit: BoxFit.fitHeight,
                                                      alignment: Alignment
                                                          .bottomCenter),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.1,
                                                child: Text(
                                                  'x${player['score']}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          )
                                        ]),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    No1
                        ? Container(
                            height: screenHeight * 0.11,
                            width: screenWidth * 0.9,
                            //padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(212, 251, 219, 1),
                              borderRadius: BorderRadius.circular(120),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: english
                                          ? screenWidth * 0.1
                                          : screenWidth * 0.02),
                                  width: english
                                      ? screenWidth * 0.7
                                      : screenWidth * 0.75,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: screenWidth * 0.7,
                                          child: Text(
                                            english
                                                ? 'If you get first place, don’t forget to take a selfie with your score and post it with the tag @grabth for a chance to win a special prize.'
                                                : 'ถ้าคุณได้ที่ 1 อย่าลืม selfie กับผลคะแนนของคุณและโพสและ tag @grabth เพื่อลุ้นรับรางวัลพิเศษ',
                                            style: TextStyle(
                                                fontSize: english
                                                    ? screenWidth * 0.027
                                                    : screenWidth * 0.03,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // Text(
                                        //   english
                                        //       ? "Please stay tuned for the prize announcement on March 7, 2025."
                                        //       : 'โปรดติดตามประกาศผลรางวัลวันที่ 7 มีนาคม 2568',
                                        //   style: TextStyle(
                                        //       fontSize: english
                                        //           ? screenWidth * 0.025
                                        //           : screenWidth * 0.03,
                                        //       fontWeight: FontWeight.normal),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Image.asset('assets/FBIcon.png',
                                          width: screenWidth * 0.15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 177, 79, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(180)),
                              minimumSize:
                                  Size(screenWidth * 0.8, screenHeight * 0.085),
                            ),
                            onPressed: () {
                              buttonSound();
                              reloadApp(context);
                            },
                            child: Text(
                              english ? 'Back to Home' : 'กลับสู่หน้าแรก',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: screenWidth * 0.375,
            top: screenHeight * 0.1,
            child: Container(
              height: screenWidth * 0.225,
              width: screenWidth * 0.225,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/rewardIcon.png"),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.bottomCenter),
              ),
            ),
          ),
          _loading ? LoadingScreen() : SizedBox()
        ],
      ),
    );
  }
}
