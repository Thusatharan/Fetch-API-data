import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//..........................................................
List<CreatedBy> _createdBy = List<CreatedBy>();

Future<List<CreatedBy>> fetchCreatedBy() async {
  final response = await http.get('https://api.mocki.io/v1/d91db551');

  var createdBy = List<CreatedBy>();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    // print(response.body);
    // return CreatedBy.fromJson(jsonDecode(response.body));

    var createdByjson = json.decode(response.body);
    for (var jsonData in createdByjson) {
      createdBy.add(CreatedBy.fromJson(jsonData));
    }
    return createdBy;
  }
}

//..................................................

class CreatedBy {
  final String createBy;

  CreatedBy({this.createBy});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      createBy: json['mcreatedby'],
    );
  }
}

//...................................................

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    fetchCreatedBy().then((value) {
      setState(() {
        _createdBy.addAll(value);
      });
    });
    super.initState();
    // _createdBy = fetchCreatedBy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _createdBy.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_createdBy[index].createBy),
              );
            },
          ),

          // FutureBuilder<CreatedBy>(
          //   future: futureCreatedBy,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Text(
          //         snapshot.data.createBy,
          //         style: TextStyle(color: Colors.pink[200], fontSize: 30),
          //       );
          //     } else if (snapshot.hasError) {
          //       return Text("Not Getting data");
          //     }

          //     // By default, show a loading spinner.
          //     return CircularProgressIndicator();
          //   },
          // ),
        ),
      ),
    );
  }
}
