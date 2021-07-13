import 'package:flutter/material.dart';
import 'package:subaru_soundboard/widgets/sound_button.dart';
import 'package:subaru_soundboard/strings/sounds.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(App());
  runApp(SubaruSoundboard());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          return SubaruSoundboard();
        });
  }
}

class SubaruSoundboard extends StatelessWidget {
  const SubaruSoundboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: "Kei",
            textTheme: TextTheme(
                button: TextStyle(color: Color(0xFFF45702)),
                headline6: TextStyle(
                    fontSize: 72.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFEF0)))),
        home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, String> getSounds = Sounds.sounds;
  List<Widget> rows = List.empty(growable: true);
  List<Widget> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getSounds.forEach((key, value) {
      list.add(SoundButton(description: key, filename: value));
    });
    for (var i = 0; i < list.length; i = i + 3) {
      if (i + 3 >= list.length) {
        var j = i;
        List<Widget> last = List.empty(growable: true);
        for (; j < list.length; j++) {
          last.add(Expanded(child: list[j]));
        }
        rows.add(Row(children: last));
      } else {
        rows.add(Row(children: [
          Expanded(child: list[i]),
          Expanded(child: list[i + 1]),
          Expanded(child: list[i + 2])
        ]));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Container(
            decoration: buildBoxDecoration(),
            child:buildLayoutBuilder()/* GridView.count(
              crossAxisCount: 3,
              children: list,
            )*/));
  }

  LayoutBuilder buildLayoutBuilder() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(padding: EdgeInsets.all(16),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: rows)));
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Subaru Soundboard",
              style: Theme.of(context).textTheme.headline6)),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[Color(0xFFFFAB86), Color(0xFFFF6F62)],
      ))),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment(-0.89, 0),
            stops: [0.0, 0.6, 0.6, 1],
            colors: <Color>[
              Color(0xFFAED9FF),
              Color(0xFFAED9FF),
              Color(0xFFD2EAFF),
              Color(0xFFD2EAFF)
            ],
            tileMode: TileMode.repeated));
  }
}
