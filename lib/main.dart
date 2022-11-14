import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// fa22_drawers

/*
https://pub.dev/packages/http
https://pub.dev/packages/


pubsec.yaml

dependencies:
flutter:
  sdk: flutter

http: ^0.13.5
*/

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: const MyApp(), routes: <String, WidgetBuilder>{
    "/HomePage": (BuildContext context) => const MyApp(),
    "/downloadedPage": (BuildContext context) => const downloadedJson(),
    "/APIPage": (BuildContext context) => const ApiJson()
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushNamed(pages[index]);
    });
  }

  List pages = ["/downloadedPage", "/HomePage", "/APIPage"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Json App")),
      body: Container(
        alignment: Alignment.center,
        child: Text("Welcome to my JSON Project App! Click the left"
            " button to go to the Ikea downloaded JSON page."
            " Tap the bottom right button to see the API JSON of Magic Spells!")


      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined),
              label: 'Downloaded',
              backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.yellowAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Online API',
              backgroundColor: Colors.blueAccent),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ApiJson extends StatefulWidget {
  const ApiJson({Key? key}) : super(key: key);

  @override
  _ApiJson createState() => _ApiJson();
}

class _ApiJson extends State<ApiJson> {
  static var data;

  static Future getData() async {
    var url = Uri.parse("https://flutter.locusnoesis.com/spellsinfo.php");

    //http.Response response = await http.get(url);
    http.Response response = await http.post(url);
    data = await jsonDecode(response.body);

    return data;
  }

  Widget myWidget = FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
              interactive: true,
              thickness: 10,
              thumbVisibility: true,
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          ListTile(
                              title: Text(data[index]['spellname'] +
                                  ": " +
                                  data[index]['incantation']),
                              subtitle: Text(data[index]['effect']))
                        ]));
                  }));
        }
        return const Text("Waiting For Data");
      });

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushNamed(pages[index]);
    });
  }

  List pages = ["/downloadedPage", "/HomePage", "/APIPage"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("JSON from API"),
            backgroundColor: Colors.indigo),
        body: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: const Text("Spells")),
          Expanded(child: myWidget)
        ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined),
              label: 'Downloaded',
              backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.yellowAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Online API',
              backgroundColor: Colors.blueAccent),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),);
  }
}

class downloadedJson extends StatefulWidget {
  const downloadedJson({Key? key}) : super(key: key);

  @override
  _downloadedJson createState() => _downloadedJson();
}

class _downloadedJson extends State<downloadedJson> {
  List _ikea = [];

  //fetch content from json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString("assets/ikea.json");
    final data = await json.decode(response);

    setState(() {
      _ikea = data;
    });
  }


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushNamed(pages[index]);
    });
  }

  List pages = ["/downloadedPage", "/HomePage", "/APIPage"];

  var styler = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: const Text("Read Downloaded Json - Ikea Catalogue")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            ElevatedButton(child: const Text('Load Data'), onPressed: readJson),
            _ikea.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: _ikea.length,
                        itemBuilder: (context, index) {
                          //example with card
                          return (Container(color: Colors.lightBlue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Item ID#" + _ikea[index][1].toString(), style: styler),
                                Text("Item Name: ${_ikea[index][2]}", style: styler),
                                Text("Category: ${_ikea[index][3]}", style: styler),
                                Text("Price: ${_ikea[index][4]}", style: styler),
                                const Divider(
                                    height: 10,
                                    thickness: 3,
                                    color: Colors.yellow)
                              ],
                            ),
                          ));
                        }))
                : Container()
          ]),
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined),
              label: 'Downloaded',
              backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.yellowAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Online API',
              backgroundColor: Colors.blueAccent),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),);
  }
}
