import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static int i = 0;
  static late final StreamController<int> controller;

  final Stream<int> _bids = (() {
    controller = StreamController<int>(onListen: () async {
      await Future<void>.delayed(const Duration(seconds: 1));
      controller.add(i);
    });

    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: _bids,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                          style: Theme.of(context).textTheme.headline2,
                        );
                      } else {
                        return Text('No Data');
                      }
                    }
                    return Text('Something Wrong');
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      i++;
                      controller.add(i);
                      print(i);
                    },
                    child: Icon(Icons.add),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      i--;
                      controller.add(i);
                      print(i);
                    },
                    child: Icon(Icons.remove),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
