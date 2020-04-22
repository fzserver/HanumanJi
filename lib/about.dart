import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class About extends StatelessWidget {
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
}

Widget aboutBody() => SingleChildScrollView(
    child: Card(
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
        )));
