import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:HanumanChalisa/prayer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(HanumanJi());
}

class HanumanJi extends StatelessWidget {
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  @override
  Widget build(BuildContext context) {
    bool iOS = Platform.isIOS;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanuman Chalisa',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: Hanuman(isiOS: iOS,),
    );
  }
}

class Hanuman extends StatefulWidget {
  bool isiOS;
  Hanuman({this.isiOS});
  @override
  _HanumanState createState() => _HanumanState();
}

class _HanumanState extends State<Hanuman> {
  AudioPlayer audioPlayer = AudioPlayer();
  int playaudio;
  String prayer;

  playpause(int play) async {
    switch (play) {
      case 0:
        {
          setState(() {
            playaudio = 1;
          });
          await audioPlayer.play(
              'https://firebasestorage.googleapis.com/v0/b/flutter-884a9.appspot.com/o/Hanuman.mp3?alt=media&token=a33a2b6f-eada-4deb-b7bd-76933d52576c');
        }
        break;
      case 1:
        {
          setState(() {
            playaudio = 2;
          });
          await audioPlayer.pause();
        }
        break;
      case 2:
        {
          setState(() {
            playaudio = 1;
          });
          await audioPlayer.resume();
        }
        break;
    }
  }

  Widget playerIcon() {
    if (playaudio != 1) {
      return Icon(
        Icons.play_arrow,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.pause,
        color: Colors.white,
      );
    }
  }

  // Admob Implementation
  static final MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
    testDevices: <String>["52161986C14504D2EE7019AAC96D045E"],
    keywords: <String>[
      'WALLPAPERS',
      'WALLS',
      'AMOLED',
      'Hanuman',
      'God',
      'Goddess',
      'Prayer',
      'Ram',
    ],
    childDirected: true,
  );

  BannerAd _bannerAd;
  String bannerAdUnitId =  widget.isiOS == true ?'ca-app-pub-7600031190372955/9354587981' :'ca-app-pub-7600031190372955/8284446258';

  BannerAd createBannerAd() => BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetInfo,
      listener: (MobileAdEvent event) {
        print("Banner event : $event");
      });

  // init State
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7600031190372955~4536772939');
    prayer = hanumanprayer();
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    playaudio = 0;
  }

  // dispose
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Hanuman Chalisa',
            style: TextStyle(color: Colors.deepOrange),
          ),
          elevation: 1.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => {},
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    child: SafeArea(
                      child: Hero(
                        child: FadeInImage(
                          image: AssetImage('hanumanji.jpg'),
                          fit: BoxFit.cover,
                          placeholder: AssetImage('hanumanji.jpg'),
                        ),
                        tag: "Jai Hanuman Ji",
                      ),
                    ),
                  ),
                ),
                // Card(
                //   child: SafeArea(
                //     child: ListTile(
                //       title: Text(
                //         'Hanuman Chalisa',
                //         style: TextStyle(
                //             color: Colors.deepOrange, fontSize: 18.0),
                //       ),
                //       subtitle: Text(
                //         'By Hariharan',
                //         style: TextStyle(
                //             color: Colors.deepOrangeAccent, fontSize: 14.0),
                //       ),
                //       trailing: RawMaterialButton(
                //         child: playerIcon(),
                //         onPressed: () => playpause(playaudio),
                //         fillColor: Colors.deepOrange,
                //         splashColor: Colors.deepOrangeAccent,
                //       ),
                //     ),
                //   ),
                // ),
                Card(
                  child: SafeArea(
                    // child: SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('$prayer',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w200)),
                    ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          child: playerIcon(),
          onPressed: () => playpause(playaudio),
        ),
      );
}
