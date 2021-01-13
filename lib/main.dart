import 'package:hanumanji/MenuItems.dart';
import 'package:hanumanji/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hanumanji/prayer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io' show Platform;

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Hanuman());
}

enum PlayerStatus { Playing, Paused, Stop, Resume }

class Hanuman extends StatefulWidget {
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

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

  @override
  HanumanState createState() {
    return new HanumanState();
  }
}

class HanumanState extends State<Hanuman> {
  BannerAd _bannerAd;

  String bannerAdUnitId =
      // Platform.isIOS
      // ? 'ca-app-pub-7600031190372955/9354587981'
      // :
      'ca-app-pub-3595684883769922/9241531200';

  BannerAd createBannerAd() => BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      targetingInfo: Hanuman.targetInfo,
      listener: (MobileAdEvent event) {
        print("Banner event : $event");
      });

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(
        appId:
            // Platform.isIOS
            // ? 'ca-app-pub-7600031190372955~9988356267'
            // :
            'ca-app-pub-3595684883769922~3126892458');
    _bannerAd = createBannerAd()..load();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hanuman Chalisa',
        navigatorObservers: <NavigatorObserver>[Hanuman.observer],
        theme: ThemeData(
          primaryColor: Colors.yellowAccent,
          accentColor: Colors.deepOrange,
        ),
        builder: (BuildContext context, Widget widget) {
          _bannerAd..show();

          // var mediaQuery = MediaQuery.of(context);
          double paddingBottom = 50.0;
          double paddingRight = 0.0;

          return Padding(
            child: widget,
            padding:
                EdgeInsets.only(bottom: paddingBottom, right: paddingRight),
          );
        },
        home: Hanumanji(),
      );
}

class Hanumanji extends StatefulWidget {
  @override
  _HanumanjiState createState() => _HanumanjiState();
}

class _HanumanjiState extends State<Hanumanji> {
  AudioPlayer audioPlayer = AudioPlayer();
  int playaudio;
  String prayer;
  String prayerurl;

  int currentPlaying;
  PlayerStatus _playerStatus;

  playpause(String url) async {
    PlayerStatus _playerStatusUpdate;
    if (_playerStatus == PlayerStatus.Playing) {
      await audioPlayer.pause();
      _playerStatusUpdate = PlayerStatus.Paused;
    } else if (_playerStatus == PlayerStatus.Paused) {
      await audioPlayer.resume();
      _playerStatusUpdate = PlayerStatus.Playing;
    } else {
      await audioPlayer.play(url);
      _playerStatusUpdate = PlayerStatus.Playing;
    }
    setState(() {
      _playerStatus = _playerStatusUpdate;
    });
  }

  Widget playerIcon() {
    if (_playerStatus == PlayerStatus.Playing) {
      return Icon(
        Icons.pause,
        color: Colors.deepOrange,
      );
    }
    return Icon(
      Icons.play_arrow,
      color: Colors.deepOrange,
    );
  }

  // init State
  @override
  void initState() {
    super.initState();
    prayer = hanumanprayer();
    prayerurl = hanumanaudio();
    playaudio = 0;
    currentPlaying = -1;
    _playerStatus = PlayerStatus.Stop;
  }

  // dispose
  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.deepOrange,
          ),
          title: Text(
            'Hanuman Chalisa',
            style: TextStyle(color: Colors.deepOrange),
          ),
          elevation: 1.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.deepOrange,
              ),
              onPressed: () => {},
            ),
            PopupMenuButton<MenuItems>(
              elevation: 3.0,
              onCanceled: () => {},
              tooltip: "Menu",
              onSelected: selectedMenuItem,
              itemBuilder: (BuildContext context) {
                return menu.map((MenuItems menuItem) {
                  return PopupMenuItem<MenuItems>(
                    value: menuItem,
                    child: Text(menuItem.title),
                  );
                }).toList();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 2.0),
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
                    color: Colors.yellow,
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
                Card(
                  elevation: 2.0,
                  color: Colors.yellowAccent,
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
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.deepOrange,
          child: playerIcon(),
          onPressed: () => playpause('$prayerurl'),
        ),
      );

  void selectedMenuItem(MenuItems menu) {
    switch (menu.id) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => About()));
        break;
      // case 1:
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Settings()));
      //   break;
      // case 2:
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Donate()));
      //   break;
    }
  }

  static const List<MenuItems> menu = const <MenuItems>[
    const MenuItems(id: 0, title: 'About'),
    // const MenuItems(id: 1, title: 'Settings'),
    // const MenuItems(id: 2, title: 'Donate'),
  ];
}
