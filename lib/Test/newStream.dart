import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const StreamApp());
}

class StreamApp extends StatefulWidget {
  const StreamApp({Key? key}) : super(key: key);

  @override
  State<StreamApp> createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  final StreamController<int> _controller = StreamController();

  Stream<int> generateNumbers() async* {
    await Future<void>.delayed(const Duration(seconds: 2));

    for (int i = 0; i <= 10; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield i;
    }
  }

  Stream<int> control() {
    late final StreamController<int> controller;
    controller = StreamController<int>(
      onListen: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        controller.add(1);
        await Future<void>.delayed(const Duration(seconds: 1));
        await controller.close();
      },
    );

    return controller.stream;
  }

  final double _bids = (() {
    return 1.0;
  })();

  double dd() {
     return 1;
  }

  void mm(double ss) {
    double ss = dd();
    print('ss');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: StreamBuilder(
                stream: control(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Connection State ${snapshot.connectionState}');
                  } else {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      return Text(
                        snapshot.data.toString(),
                        style: Theme.of(context).textTheme.headline2,
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const Text('Task Completed');
                    } else if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return Text('');
                    }
                  }

                  return Text('${snapshot.connectionState}');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilderDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Stream<int> generateNumbers = (() async* {
  await Future<void>.delayed(const Duration(seconds: 2));
  for (int i = 1; i <= 10; i++) {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield i;
  }
})();

class StreamBuilderDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StreamBuilderDemoState();
  }
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter StreamBuilder Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: StreamBuilder<int>(
            stream: generateNumbers,
            initialData: 0,
            builder: (
              BuildContext context,
              AsyncSnapshot<int> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      backgroundColor: Colors.cyan,
                    ),
                    Visibility(
                      visible: snapshot.hasData,
                      child: Text(
                        snapshot.data.toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return Text(snapshot.data.toString(),
                      style: const TextStyle(color: Colors.red, fontSize: 40));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ),
      ),
    );
  }
}
