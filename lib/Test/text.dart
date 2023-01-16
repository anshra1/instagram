import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CounterController _counterController;

  @override
  void initState() {
    _counterController = CounterController();
    super.initState();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Streams"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(),
          Center(
              child: StreamBuilder<int>(
                  stream: _counterController.counterStream,
                  initialData: 0,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<int> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return Text(
                        '${_counterController.counter}',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    } else {
                      return Text(
                        'Empty data',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    }
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                onPressed: () =>
                    _counterController.eventSink.add(Event.decrement),
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () =>
                    _counterController.eventSink.add(Event.increment),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum Event { increment, decrement }

class CounterController {
  int counter = 0;

  // this will handle the change the change in value of counter
  final StreamController<int> _counterController = StreamController<int>();

  StreamSink<int> get counterSink => _counterController.sink;

  Stream<int> get counterStream  => _counterController.stream;

  // we can directly use the counter sink from widget itself but to reduce the logic
  // from the UI files we are making use of one more controller that will listen to
  // button click events by user.

  final StreamController<Event> _eventController = StreamController<Event>();

  StreamSink<Event> get eventSink => _eventController.sink;

  Stream<Event> get eventStream => _eventController.stream;

  // NOTE: here we will use listener to listen the _eventController
  StreamSubscription? listener;

  CounterController() {
    listener = eventStream.listen((Event event) {
      switch (event) {
        case Event.increment:
          counter += 1;

          break;
        case Event.decrement:
          counter -= 1;
          break;
        default:
      }
      counterSink.add(counter);
    });
  }

  // dispose the listner to eliminate memory leak
  dispose() {
    listener?.cancel();
    _counterController.close();
    _eventController.close();
  }
}
