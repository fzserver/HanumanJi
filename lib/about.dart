import 'package:flutter/material.dart';
import 'package:hanumanji/unity.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String appVersion = '';
  @override
  void initState() {
    getAppVersion();
    super.initState();
    Unity.showRewardedAd();
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.deepOrange,
          ),
          title: Text(
            'About',
            style: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
        ),
        body: aboutBody());
  }

  Widget aboutBody() => SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FadeInImage(
                      image: AssetImage('hanuman.png'),
                      placeholder: AssetImage('hanuman.png'),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Hanuman Ji',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Hanuman Chalisa a hindu prayer of Goddess Hanuman Ji to think only for Goddess Ram while praying this prayer.',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.deepOrange),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'App Version',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    Text(
                      appVersion,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
