import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline2: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          bodyText2: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Mountain View',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Clear Sky',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.wb_sunny_outlined,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '14\u00b0',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Max',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '16\u00b0',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: 2,
                      height: 45,
                      color: Colors.white,
                    ),
                    Column(
                      children: [
                        Text(
                          'Min',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '12\u00b0',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
