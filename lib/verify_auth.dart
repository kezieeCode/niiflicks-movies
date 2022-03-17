import 'package:flutter/material.dart';
import 'package:niiflicks/state/users.dart';
import 'package:niiflicks/view/intro/intro_screen.dart';
import 'package:provider/provider.dart';

class VerifyAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<UserLoggedProvider>(
        builder:
            (BuildContext context, UserLoggedProvider provider, Widget child) {
          return provider.authenticated ? IntroScreen() :  IntroScreen();
        },
      ),
    );
  }
}


