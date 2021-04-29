import 'package:docs/pages/authenticate/authenticate.dart';
import 'package:docs/pages/home.dart';
import 'package:docs/services/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return either authenticate or home
    print(user);
    return user != null ? Home() : Authenticate();
  }
}
