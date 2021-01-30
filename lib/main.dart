import 'package:hanumanji/MenuItems.dart';
import 'package:hanumanji/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hanumanji/prayer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'donate.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`
  // without this call.
  //
  // On iOS this is a no-op.
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(Hanuman());
}

enum PlayerStatus { Playing, Paused, Stop, Resume }

class Hanuman extends StatefulWidget {
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  @override
  HanumanState createState() {
    return new HanumanState();
  }
}

class HanumanState extends State<Hanuman> {
  @override
  void initState() {
    super.initState();
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
        body: SingleChildScrollView(
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
      case 1:
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Settings()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Donate()));
        break;
    }
  }

  static const List<MenuItems> menu = const <MenuItems>[
    const MenuItems(id: 0, title: 'About'),
    const MenuItems(id: 1, title: 'Settings'),
    const MenuItems(id: 2, title: 'Donate'),
  ];
}
