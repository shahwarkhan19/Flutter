import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> _futureUsers;

  @override
  void initState() {
    _futureUsers = fetchUsers();
    super.initState();
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get('https://reqres.in/api/users?page=2');
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reqres API'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _futureUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List? users = snapshot.data;
              return ListView.builder(
                itemCount: users?.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(users![index]['avatar']),
                      ),
                      title: Text(users![index]['first_name'] +
                          ' ' +
                          users[index]['last_name']),
                      subtitle: Text(users[index]['email']),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
Future<http.Response> fetchUsers() async {
  final response = await http.get('https://reqres.in/api/users?page=2');
  return response;
}
Future<http.Response> createUser(Map<String, String> data) async {
  final response = await http.post('https://reqres.in/api/users', body: data);
  return response;
}
