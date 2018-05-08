import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http2;

String url = "https://api.spacexdata.com/v2/launches";
void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List data;
  List<dynamic> firebaseData;
  int firebaseIndex;
  String username = '';
  bool oy;
  Future<String> getClient() async {
    http2.Response response = await http2
        .get(Uri.encodeFull(url), headers: {"Accept": "Application/json"});
    setState(() {
      this.data = JSON.decode(response.body);
    });
    return "Succes";
  }

  Future<String> getFirebase() async {
    http.Response response2 = await http.get(
        Uri.encodeFull("https://codenightspacex.firebaseio.com/.json"),
        headers: {"Accept": "Application/json"});

    setState(() {
      Map<String, dynamic> map = JSON.decode(response2.body);
      this.firebaseIndex = map['spacexbet']['flight_number'] - 1;
    });

    return "Succes";
  }

  Future<String> postMethod() async {
    var url = "https://codenightspacex.firebaseio.com/userbetlist/1/" +
        username +
        "/.json";

    var data = JSON.encode(oy);

    await http2
        .put(url,
            headers: {"Accept": "Application/json"},
            encoding: Encoding.getByName("utf-8"),
            body: data)
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
    http2.read(url).then(print);

    return "Succes";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("CodeNight18"),
          backgroundColor: Colors.green,
          centerTitle: true,
          actions: <Widget>[
            new RaisedButton.icon(
              label: new Text("Puan: "),
              icon: new Icon(Icons.power),
              onPressed: () {},
            ),
          ],
        ),
        body: new Container(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(12.0),
            ),
            new Container(
              color: Colors.black,
              width: 200.0,
              padding: new EdgeInsets.all(12.0),
              child: new Image.network(
                "https://secure.meetupstatic.com/photos/event/b/1/4/2/600_464985378.jpeg",
              ),
            ),
            new Text("Oylama"),
            new Container(padding: new EdgeInsets.all(12.0)),
            new Center(
                child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.network(
                  data[2]['links']['mission_patch'].toString(),
                  width: 150.0,
                  height: 150.0,
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text('Flight Number: ' +
                        data[firebaseIndex]['flight_number'].toString()),
                    new Text('Rocket name: ' +
                        data[firebaseIndex]['rocket']['rocket_name']
                            .toString()),
                    new Text(
                        'Flight Date: ' + data[2]['launch_year'].toString()),
                    new Text('Rocket Type: ' +
                        data[firebaseIndex]['rocket']['rocket_type']
                            .toString()),
                  ],
                ),
              ],
            )),
            new Container(
              padding: new EdgeInsets.all(12.0),
            ),
            new Container(
              child: new Text("Sizce bu roket düşer mi ?"),
              color: Colors.white30,
            ),
            new Container(
              padding: new EdgeInsets.all(12.0),
            ),
            new Container(
              width: 200.0,
              child: new TextField(
                onChanged: (String value) {
                  username = value;
                },
                decoration: new InputDecoration(
                  labelText: 'Kullanıcı adı giriniz',
                ),
              ),
            ),
            new Container(
              padding: new EdgeInsets.all(32.0),
            ),
            new Container(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text("Düşer"),
                    onPressed: () {
                      oy = true;
                      postMethod();
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Düşmez"),
                    onPressed: () {
                      oy = false;
                      postMethod();
                    },
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    getClient();
    getFirebase();
    super.initState();
  }
}
