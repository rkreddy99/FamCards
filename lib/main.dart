import 'package:docs/services/auth.dart';
import 'package:docs/services/user.dart';
import 'package:docs/services/wrapper.dart';
import 'package:flutter/material.dart';
// import 'package:docs/pages/choose_location.dart';
import 'package:provider/provider.dart';
// import 'package:docs/pages/loading.dart';

// void main() {
//   runApp(MaterialApp(
//     initialRoute: '/home',
//     routes: {
//       // '/': (context) => Loading(),
//       '/home': (context) => Home(),
//     },
//   ));
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
