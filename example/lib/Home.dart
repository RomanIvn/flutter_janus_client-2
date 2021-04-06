import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Janus Client Menu")),
        body: ListView(
          children: [
            ListTile(
              title: Text("Streaming V2"),
              onTap: () {
                Navigator.of(context).pushNamed("/streaming_v2");
              },
            ),
          ],
        ));
  }
}
