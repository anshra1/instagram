import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instagram/Test/newStream.dart';

void main() => runApp(const StreamApp());

class StreamApp extends StatefulWidget {
  const StreamApp({Key? key}) : super(key: key);

  @override
  State<StreamApp> createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  StreamController<double> controller = StreamController<double>.broadcast();
  late StreamSubscription streamSubscription;
  static int counter = 0;

  Stream<double> getDelayedRandomValue() async* {
    while (true) {
      var random = Random();
      await Future.delayed(const Duration(seconds: 1));
      yield random.nextDouble();
    }
  }

  StreamSubscription<double> getvalue(double m) {
    return getDelayedRandomValue().listen((event) {
      m = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                child: const Text('Controller'),
                onPressed: () {
                  Stream stream = controller.stream;
                  streamSubscription = stream.listen((event) {
                    print('Value from controller $event');
                  });
                },
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  // controller.add(12);
                  getDelayedRandomValue().listen((event) {
                    print('Value from stream $event');
                    counter == event;
                  });
                },
                child: const Text('Stream'),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  streamSubscription.cancel();
                },
                child: const Text('Describe'),
              ),
              Text(
                '${getDelayedRandomValue().listen((event) {}).toString()}',
                maxLines: 1,
                style: Theme.of(context).textTheme.headline1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp(StreamApp streamApp);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilderDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

StreamController<double> control = StreamController();
Stream stream = control.stream;

Stream<int> generateNumbers = (() async* {
  await Future<void>.delayed(Duration(seconds: 0));

  for (int i = 1; i <= 10; i++) {
    await Future<void>.delayed(Duration(microseconds: 50000));
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

  String data = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter StreamBuilder Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
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
                        CircularProgressIndicator(),
                        Visibility(
                          visible: snapshot.hasData,
                          child: Text(
                            snapshot.data.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 24),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return Text(snapshot.data.toString(),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 40));
                    } else {
                      return const Text('Empty data');
                    }
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Text('Done Work Go to Sleep');
                  } else {
                    return Text(data);
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  data = 'Hello';
                },
                child: Text('Click Me'))
          ],
        ),
      ),
    );
  }
}

class MyHomeStream extends StatefulWidget {
  const MyHomeStream({Key? key}) : super(key: key);

  @override
  State<MyHomeStream> createState() => _MyHomeStreamState();
}

class _MyHomeStreamState extends State<MyHomeStream> {
  late CounterController _counterController;

  @override
  void initState() {
    _counterController = CounterController();
    super.initState();
  }

  @override
  void dispose() {
    // _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  StreamBuilder<int>(
                    stream: _counterController.counterStream,
                    initialData: 0,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${_counterController.counter}',
                          style: Theme.of(context).textTheme.headline1,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Empty Text');
                      } else {
                        return Text('');
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  tooltip: 'Increment',
                  onPressed: () {},
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  tooltip: 'Decrement',
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum Event { increment, decrement }

class CounterController {
  int counter = 0;

  final StreamController<int> _counterController = StreamController.broadcast();

  StreamSink<int> get countersink => _counterController.sink;

  Stream<int> get counterStream => _counterController.stream;

  final StreamController<Event> _eventController = StreamController.broadcast();

  StreamSink<Event> get eventSink => _eventController.sink;

  Stream<Event> get eventStream => _eventController.stream;
  StreamSubscription? listener;

  CounterController() {
    listener = eventStream.listen((event) {
      switch (event) {
        case Event.increment:
          counter += 1;
          break;
        case Event.decrement:
          counter -= 1;
          break;
        default:
          countersink.add(counter);
      }
    });
  }

// dispose() {
//   listener?.cancel();
//   _counterController.close();
//   _eventController.close();
// }
}
