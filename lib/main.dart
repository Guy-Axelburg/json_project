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
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  int _selectedIndex = 0;
  static const TextStyle myStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);

  void _onItemTapped(int index)
  {
  setState(() {
  _selectedIndex = index;
  });
  }

  static List<Widget> _widgetOptions = [
  Text('Index 0: Home Page', style: myStyle),
  Text('Index 1: API Json', style: myStyle),
  Text('Index 2: Downloaded Json', style: myStyle),
  myWidget

  ];


  static Widget myWidget = Scrollbar(
  thickness: 10,
  thumbVisibility: true,
  child: ListView.builder(
  primary: true,
  itemCount: 50,
  itemBuilder: (BuildContext context, int index){

  return Container(
  height: 50,
  color: index.isEven?
  Colors.black26:
  Colors.grey[200],
  child: Padding(
  padding: const EdgeInsets.all(10),
  child: Text('City: '),

  ),


  );

  }
  ),

  );


  @override
  Widget build(BuildContext context)
  {
  return Scaffold(
  appBar: AppBar(title: const Text("Json App")),
  body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
  bottomNavigationBar: BottomNavigationBar(
  items: const[
  BottomNavigationBarItem(
  icon: Icon(Icons.wifi),
  label: 'Online',
  backgroundColor: Colors.blueAccent),
  BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: 'Home',
  backgroundColor: Colors.yellowAccent),
  BottomNavigationBarItem(
  icon: Icon(Icons.download_for_offline_outlined),
  label: 'Downloaded',
  backgroundColor: Colors.blueGrey),



  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.amber[800],
  onTap: _onItemTapped,

  ),
  );

  }


}


class apiJson extends StatefulWidget {
  const apiJson({Key? key}) : super(key: key);

  @override
  _apiJson createState() => _apiJson();

    }

    class _apiJson extends State <apiJson>{

  static var data;

  static Future getData() async {

    var url = Uri.parse("https://wizard-world-api.herokuapp.com/Spells");

    //http.Response response = await http.get(url);
    http.Response response = await http.post(url);
    data = await jsonDecode(response.body);

    return data;

  }


  Widget myWidget = FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        if(snapshot.hasData)
        {
          return Scrollbar(
              interactive: true,
              thickness: 10,
              thumbVisibility: true,
              child:
              ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                    title: Text(data[index]['year'].toString() +
                                        " " + data[index]['make']),
                                    subtitle: Text(data[index]['body_styles'])
                                )
                              ]
                          )
                      );
                  }
              )
          );
        }
        return const Text("Waiting For Data");
      }
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Autos Json API"),
            backgroundColor: Colors.indigo),
        body: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cars For Sale")
              ),
              Expanded(child:  myWidget)
            ]
        )
    );}
}




class downloadedJson extends StatefulWidget {
  const downloadedJson({Key? key}) : super(key: key);

  @override
  _downloadedJson createState() => _downloadedJson();
}

class _downloadedJson extends State<downloadedJson> {
  List _Movies = [];

  //fetch content from json file
  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString("assets/movies_array.json");
    final data = await json.decode(response);

    setState(() {
      _Movies = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(centerTitle: true, title: const Text("Read Json - Movies")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            ElevatedButton(child: const Text('Load Data'), onPressed: readJson),
            _Movies.isNotEmpty
                ? Expanded(
                child: ListView.builder(
                    itemCount: _Movies.length,
                    itemBuilder: (context, index) {
                      //example with card
                      return /* Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                  leading: Text(_Movies[index][0].toString()),
                                  title: Text(_Movies[index][1]),
                                  subtitle: Text(_Movies[index][6].toString()))); */


                        (
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rank ${_Movies[index][0]} "),
                                  Text(_Movies[index][1].toString()),
                                  Text(_Movies[index][2].toString() ),
                                  Text("Rating: ${_Movies[index][3]}"),
                                  Text("Year: ${_Movies[index][4]}"),
                                  Text("Genre: ${_Movies[index][6]}"),
                                  const Divider(height: 10, thickness: 3, color: Colors.indigo)

                                ],
                              ),
                            )

                        );
                    }))
                : Container()
          ]),
        ));
  }
}
