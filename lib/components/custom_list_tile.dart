import 'package:flutter/material.dart';

Widget customListTile(
    {String title, String singer, String cover, String onTap}) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(image: AssetImage(cover))),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              singer,
              style: TextStyle(color: Colors.red, fontSize: 16),
            )
          ],
        )
      ],
    ),
  );
}
