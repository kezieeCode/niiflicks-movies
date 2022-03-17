import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text('Payment was successfull thank you'),
            ),
            FloatingActionButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()))
              },
              child: Text("Go Home"),
            )
          ],
        ),
      ),
    );
  }
}
