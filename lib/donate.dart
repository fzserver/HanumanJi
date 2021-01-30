import 'package:flutter/material.dart';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepOrange,
        ),
        title: Text(
          'Donate',
          style: TextStyle(color: Colors.deepOrange),
        ),
        elevation: 1.0,
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: Text('Donate \$1'),
          color: Colors.yellow,
          textColor: Colors.deepOrange,
        ),
      ),
    );
  }
}
